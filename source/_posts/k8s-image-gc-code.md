---
title: K8S 镜像回收 代码分析
readmore: true
date: 2023-03-21 19:01:00
categories: 云原生
tags:
---

```go
// ImageGCPolicy is a policy for garbage collecting images. Policy defines an allowed band in
// which garbage collection will be run.
type ImageGCPolicy struct {
	// Any usage above this threshold will always trigger garbage collection.
	// This is the highest usage we will allow.
	HighThresholdPercent int

	// Any usage below this threshold will never trigger garbage collection.
	// This is the lowest threshold we will try to garbage collect to.
	LowThresholdPercent int

	// Minimum age at which an image can be garbage collected.
	MinAge time.Duration
}
```

kubelet 镜像垃圾回收的参数:

    --image-gc-high-threshold: 当磁盘使用率超过 85%, 则进行垃圾回收, 默认为 85%.
    --image-gc-low-threshold: 当空间已经小于 80%, 则停止垃圾回收, 默认为 80%.
    --minimum-image-ttl-duration: 镜像的最低存留时间, 默认为 2m0s.


```go
// ImageGCManager is an interface for managing lifecycle of all images.
// Implementation is thread-safe.
type ImageGCManager interface {
	// Applies the garbage collection policy. Errors include being unable to free
	// enough space as per the garbage collection policy.
	GarbageCollect(ctx context.Context) error

	// Start async garbage collection of images.
	Start()

	GetImageList() ([]container.Image, error)

	// Delete all unused images.
	DeleteUnusedImages(ctx context.Context) error
}
```

```go
// GarbageCollect 执行镜像垃圾回收工作
// 1. im.statsProvider.ImageFsStats(ctx) 获取文件状态，主要获取可用字节数 fsStats.AvailableBytes 和 总容量字节数 fsStats.CapacityBytes
// 2. 出现 available > capacity 异常情况，修正 available 值： available = capacity
// 3. 出现 capacity == 0 异常情况，im.recorder.Eventf 发送错误到K8S event record，并 return 错误
// 4. 出现 使用率 usagePercent 超过阈值 im.policy.HighThresholdPercent，则执行镜像垃圾回收工作，否则retrun nil
// 5. 根据阈值 im.policy.LowThresholdPercent 计算应该释放的硬盘空间大小 amountToFree
// 6. 将amountToFree作为 执行镜像垃圾回收工作函数im.freeSpace 的入参
// 7. 若im.freeSpace不能释放入参amountToFree的硬盘空间，则发送错误到K8S event record，并 return 错误
func (im *realImageGCManager) GarbageCollect(ctx context.Context) error {
	// Get disk usage on disk holding images.
	fsStats, err := im.statsProvider.ImageFsStats(ctx)
	if err != nil {
		return err
	}

	var capacity, available int64
	if fsStats.CapacityBytes != nil {
		capacity = int64(*fsStats.CapacityBytes)
	}
	if fsStats.AvailableBytes != nil {
		available = int64(*fsStats.AvailableBytes)
	}

	if available > capacity {
		klog.InfoS("Availability is larger than capacity", "available", available, "capacity", capacity)
		available = capacity
	}

	// Check valid capacity.
	if capacity == 0 {
		err := goerrors.New("invalid capacity 0 on image filesystem")
		im.recorder.Eventf(im.nodeRef, v1.EventTypeWarning, events.InvalidDiskCapacity, err.Error())
		return err
	}

	// If over the max threshold, free enough to place us at the lower threshold.
	usagePercent := 100 - int(available*100/capacity)
	if usagePercent >= im.policy.HighThresholdPercent {
		amountToFree := capacity*int64(100-im.policy.LowThresholdPercent)/100 - available
		klog.InfoS("Disk usage on image filesystem is over the high threshold, trying to free bytes down to the low threshold", "usage", usagePercent, "highThreshold", im.policy.HighThresholdPercent, "amountToFree", amountToFree, "lowThreshold", im.policy.LowThresholdPercent)
		freed, err := im.freeSpace(ctx, amountToFree, time.Now())
		if err != nil {
			return err
		}

		if freed < amountToFree {
			err := fmt.Errorf("Failed to garbage collect required amount of images. Attempted to free %d bytes, but only found %d bytes eligible to free.", amountToFree, freed)
			im.recorder.Eventf(im.nodeRef, v1.EventTypeWarning, events.FreeDiskSpaceFailed, err.Error())
			return err
		}
	}

	return nil
}
```

```go
// Tries to free bytesToFree worth of images on the disk.
//
// Returns the number of bytes free and an error if any occurred. The number of
// bytes freed is always returned.
// Note that error may be nil and the number of bytes free may be less
// than bytesToFree.
// freeSpace 用来清理没在使用的 docker image 镜像, 已达到释放空间的目的. 先获取正在使用 images 列表, 然后遍历 imageRecords 集合获取未被使用的 images 列表.
// 对未使用的 images 按照 LRU 进行排序, 最久使用的放在前面，然后遍历 images 列表，删除老镜像（忽略不满足最短时间im.policy.MinAge的镜像）
// 如果释放的空间不够则继续遍历, 直到满足释放空间要求.
func (im *realImageGCManager) freeSpace(ctx context.Context, bytesToFree int64, freeTime time.Time) (int64, error) {
	imagesInUse, err := im.detectImages(ctx, freeTime)
	if err != nil {
		return 0, err
	}

	im.imageRecordsLock.Lock()
	defer im.imageRecordsLock.Unlock()

	// Get all images in eviction order.
	images := make([]evictionInfo, 0, len(im.imageRecords))
	for image, record := range im.imageRecords {
		if isImageUsed(image, imagesInUse) {
			klog.V(5).InfoS("Image ID is being used", "imageID", image)
			continue
		}
		// Check if image is pinned, prevent garbage collection
		if record.pinned {
			klog.V(5).InfoS("Image is pinned, skipping garbage collection", "imageID", image)
			continue

		}
		images = append(images, evictionInfo{
			id:          image,
			imageRecord: *record,
		})
	}
	sort.Sort(byLastUsedAndDetected(images))

	// Delete unused images until we've freed up enough space.
	var deletionErrors []error
	spaceFreed := int64(0)
	for _, image := range images {
		klog.V(5).InfoS("Evaluating image ID for possible garbage collection", "imageID", image.id)
		// Images that are currently in used were given a newer lastUsed.
		if image.lastUsed.Equal(freeTime) || image.lastUsed.After(freeTime) {
			klog.V(5).InfoS("Image ID was used too recently, not eligible for garbage collection", "imageID", image.id, "lastUsed", image.lastUsed, "freeTime", freeTime)
			continue
		}

		// Avoid garbage collect the image if the image is not old enough.
		// In such a case, the image may have just been pulled down, and will be used by a container right away.

		if freeTime.Sub(image.firstDetected) < im.policy.MinAge {
			klog.V(5).InfoS("Image ID's age is less than the policy's minAge, not eligible for garbage collection", "imageID", image.id, "age", freeTime.Sub(image.firstDetected), "minAge", im.policy.MinAge)
			continue
		}

		// Remove image. Continue despite errors.
		klog.InfoS("Removing image to free bytes", "imageID", image.id, "size", image.size)
		// 调用底层的cri的删除镜像接口
		err := im.runtime.RemoveImage(ctx, container.ImageSpec{Image: image.id})
		if err != nil {
			deletionErrors = append(deletionErrors, err)
			continue
		}
		// 将key：image.id从map im.imageRecords中删除
		delete(im.imageRecords, image.id)
		spaceFreed += image.size

		// 一旦满足入参的清理空间大小的要求，则跳出循环
		if spaceFreed >= bytesToFree {
			break
		}
	}

	if len(deletionErrors) > 0 {
		return spaceFreed, fmt.Errorf("wanted to free %d bytes, but freed %d bytes space with errors in image deletion: %v", bytesToFree, spaceFreed, errors.NewAggregate(deletionErrors))
	}
	return spaceFreed, nil
}
```

