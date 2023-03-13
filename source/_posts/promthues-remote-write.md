---
title: Promthues远程写源码分析
readmore: true
date: 2023-03-13 18:50:32
categories: 云原生
tags:
---

Prometheus 支持自定义的存储格式将样本数据保存在本地磁盘当中。但Prometheus 的本地存储并不能实现长期的持久化存储，且无法灵活扩展。为了保持Prometheus的简单性，Prometheus并没有尝试在自身中解决以上问题，而是通过定义两个标准接口（remote_write/remote_read），让用户可以基于这两个接口对接将数据保存到任意第三方的存储服务中，这种方式在 Promthues 中称为 Remote Storage。目前主流的第三方存储是InfluxDB和Kafka，国内出名的是腾讯的TiKV。

使用第三方存储的灵活性还体现在将分散的监控数据集中起来。就是将多个Prometheus的数据源集中起来，实现聚合查询。例如如果要采集的服务比较多，一个 Prometheus 实例就配置成仅采集和存储某一个或某一部分服务的指标，这样根据要采集的服务将 Prometheus 拆分成多个实例分别去采集，也能一定程度上达到水平扩容的目的。使用第三方存储可以将分散的多个Prometheus监控数据集中起来。

本篇是讲解为了实现上述目标，而设计的 Prometheus 的 remote_write 接口的源码。

prometheus 的remote-write配置example：

```yaml
remote_write:
- url: https://1.2.3.4/api/monitor/v1/prom/write
  remote_timeout: 30s
  tls_config:
    insecure_skip_verify: true
  queue_config:
    capacity: 500 # 每个shard的容量
    max_shards: 1000 # 最大分片数
    min_shards: 1 # 最小分片数
    max_samples_per_send: 100 # 每秒最大sample数目
    batch_send_deadline: 5s # 批量发送超时时间
    min_backoff: 30ms # 最小回退时间
    max_backoff: 100ms # 最大回退时间
```

Prometheus 的 main 方法 会将 上面的配置文件的配置信息load进去。

```go
reloaders := []reloader{
		// ...
		{
			name:     "remote_storage",
			reloader: remoteStorage.ApplyConfig,
		}
        // ...
```

```go
func (s *Storage) ApplyConfig(conf *config.Config) error {
	s.mtx.Lock()
	defer s.mtx.Unlock()
    // 读取配置信息
	if err := s.rws.ApplyConfig(conf); err != nil {
		return err
	}
    // ...
    // start QueueManager
}
```

```go
// Start the queue manager sending samples to the remote storage.
// Does not block.
func (t *QueueManager) Start() {
	// ...
	t.shards.start(t.numShards)
	t.watcher.Start()
    // ...
	go t.updateShardsLoop()
	go t.reshardLoop()
}
```

QueueManager start()做的事情：
1. shards.Start()：为每个shard启动1个Goroutine干活；
2. watcher.Start(): 监听watcher的变化，将wal新增数据写入shards;
3. updateShardsLoop(): 定期根据sample in / sample out计算新的shard;
4. reshardLoop(): 更新shard;

下面分析这四个方法：

# shards.Start()

```go
func (s *shards) start(n int) {
    // ...
	for i := 0; i < n; i++ {
		go s.runShard(hardShutdownCtx, i, newQueues[i])
	}
}
```

```go
func (s *shards) runShard(ctx context.Context, shardID int, queue *queue) {
	defer func() {
		if s.running.Dec() == 0 {
			close(s.done)
		}
	}()

	shardNum := strconv.Itoa(shardID)

	// Send batches of at most MaxSamplesPerSend samples to the remote storage.
	// If we have fewer samples than that, flush them out after a deadline anyways.
	var (
		max = s.qm.cfg.MaxSamplesPerSend

		pBuf = proto.NewBuffer(nil)
		buf  []byte
	)
	if s.qm.sendExemplars {
		max += int(float64(max) * 0.1)
	}

	batchQueue := queue.Chan()
	pendingData := make([]prompb.TimeSeries, max)
	for i := range pendingData {
		pendingData[i].Samples = []prompb.Sample{{}}
		if s.qm.sendExemplars {
			pendingData[i].Exemplars = []prompb.Exemplar{{}}
		}
	}

	timer := time.NewTimer(time.Duration(s.qm.cfg.BatchSendDeadline))
	stop := func() {
		if !timer.Stop() {
			select {
			case <-timer.C:
			default:
			}
		}
	}
	defer stop()

	for {
		select {
		case <-ctx.Done():
			// In this case we drop all samples in the buffer and the queue.
			// Remove them from pending and mark them as failed.
			droppedSamples := int(s.enqueuedSamples.Load())
			droppedExemplars := int(s.enqueuedExemplars.Load())
			droppedHistograms := int(s.enqueuedHistograms.Load())
			s.qm.metrics.pendingSamples.Sub(float64(droppedSamples))
			s.qm.metrics.pendingExemplars.Sub(float64(droppedExemplars))
			s.qm.metrics.pendingHistograms.Sub(float64(droppedHistograms))
			s.qm.metrics.failedSamplesTotal.Add(float64(droppedSamples))
			s.qm.metrics.failedExemplarsTotal.Add(float64(droppedExemplars))
			s.qm.metrics.failedHistogramsTotal.Add(float64(droppedHistograms))
			s.samplesDroppedOnHardShutdown.Add(uint32(droppedSamples))
			s.exemplarsDroppedOnHardShutdown.Add(uint32(droppedExemplars))
			s.histogramsDroppedOnHardShutdown.Add(uint32(droppedHistograms))
			return

		case batch, ok := <-batchQueue:
			if !ok {
				return
			}
			nPendingSamples, nPendingExemplars, nPendingHistograms := s.populateTimeSeries(batch, pendingData)
			queue.ReturnForReuse(batch)
			n := nPendingSamples + nPendingExemplars + nPendingHistograms
			s.sendSamples(ctx, pendingData[:n], nPendingSamples, nPendingExemplars, nPendingHistograms, pBuf, &buf)

			stop()
			timer.Reset(time.Duration(s.qm.cfg.BatchSendDeadline))

		case <-timer.C:
			batch := queue.Batch()
			if len(batch) > 0 {
				nPendingSamples, nPendingExemplars, nPendingHistograms := s.populateTimeSeries(batch, pendingData)
				n := nPendingSamples + nPendingExemplars + nPendingHistograms
				level.Debug(s.qm.logger).Log("msg", "runShard timer ticked, sending buffered data", "samples", nPendingSamples,
					"exemplars", nPendingExemplars, "shard", shardNum, "histograms", nPendingHistograms)
				s.sendSamples(ctx, pendingData[:n], nPendingSamples, nPendingExemplars, nPendingHistograms, pBuf, &buf)
			}
			queue.ReturnForReuse(batch)
			timer.Reset(time.Duration(s.qm.cfg.BatchSendDeadline))
		}
	}
}
```

runShard干的事情如下：

queueManager中有一个samples数组，接收watcher发送给queue的数据。

发送给remote的时机：
* 定时：定时器事件到，cfg.BatchSendDeadLine;
* 定量：samples数组大小达到cfg.MaxSamplesPerSend;

# watcher.Start()

```go
func (t *QueueManager) Append(samples []record.RefSample) bool {
outer:
	for _, s := range samples {
		t.seriesMtx.Lock()
		lbls, ok := t.seriesLabels[s.Ref]
		if !ok {
			t.metrics.droppedSamplesTotal.Inc()
			t.dataDropped.incr(1)
			if _, ok := t.droppedSeries[s.Ref]; !ok {
				level.Info(t.logger).Log("msg", "Dropped sample for series that was not explicitly dropped via relabelling", "ref", s.Ref)
			}
			t.seriesMtx.Unlock()
			continue
		}
		t.seriesMtx.Unlock()
		// Start with a very small backoff. This should not be t.cfg.MinBackoff
		// as it can happen without errors, and we want to pickup work after
		// filling a queue/resharding as quickly as possible.
		// TODO: Consider using the average duration of a request as the backoff.
		backoff := model.Duration(5 * time.Millisecond)
		for {
			select {
			case <-t.quit:
				return false
			default:
			}
			if t.shards.enqueue(s.Ref, timeSeries{
				seriesLabels: lbls,
				timestamp:    s.T,
				value:        s.V,
				sType:        tSample,
			}) {
				continue outer
			}

			t.metrics.enqueueRetriesTotal.Inc()
			time.Sleep(time.Duration(backoff))
			backoff = backoff * 2
			// It is reasonable to use t.cfg.MaxBackoff here, as if we have hit
			// the full backoff we are likely waiting for external resources.
			if backoff > t.cfg.MaxBackoff {
				backoff = t.cfg.MaxBackoff
			}
		}
	}
	return true
}
```

遍历入参的samples数组，使用t.shards.enqueue将sample入队；若入队失败，2倍时间回退，直到最大回退值。

# updateShardsLoop()

calculateDesiredShards()方法 定期更新Shards。

```go
func (t *QueueManager) updateShardsLoop() {
	defer t.wg.Done()

	ticker := time.NewTicker(shardUpdateDuration)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			desiredShards := t.calculateDesiredShards()
			if !t.shouldReshard(desiredShards) {
				continue
			}
			// Resharding can take some time, and we want this loop
			// to stay close to shardUpdateDuration.
			select {
			case t.reshardChan <- desiredShards:
				level.Info(t.logger).Log("msg", "Remote storage resharding", "from", t.numShards, "to", desiredShards)
				t.numShards = desiredShards
			default:
				level.Info(t.logger).Log("msg", "Currently resharding, skipping.")
			}
		case <-t.quit:
			return
		}
	}
}
```

calculateDesiredShards 返回所需分片的数量，该函数只计算应该的分片数目 QueueManager.numShards。由调用方根据返回值重新分片或不重新分片。

```go
// calculateDesiredShards returns the number of desired shards, which will be
// the current QueueManager.numShards if resharding should not occur for reasons
// outlined in this functions implementation. It is up to the caller to reshard, or not,
// based on the return value.
func (t *QueueManager) calculateDesiredShards() int {
	t.dataOut.tick()
	t.dataDropped.tick()
	t.dataOutDuration.tick()

	// We use the number of incoming samples as a prediction of how much work we
	// will need to do next iteration.  We add to this any pending samples
	// (received - send) so we can catch up with any backlog. We use the average
	// outgoing batch latency to work out how many shards we need.
	var (
		dataInRate      = t.dataIn.rate()
		dataOutRate     = t.dataOut.rate()
		dataKeptRatio   = dataOutRate / (t.dataDropped.rate() + dataOutRate)
		dataOutDuration = t.dataOutDuration.rate() / float64(time.Second)
		dataPendingRate = dataInRate*dataKeptRatio - dataOutRate
		highestSent     = t.metrics.highestSentTimestamp.Get()
		highestRecv     = t.highestRecvTimestamp.Get()
		delay           = highestRecv - highestSent
		dataPending     = delay * dataInRate * dataKeptRatio
	)

	if dataOutRate <= 0 {
		return t.numShards
	}

	var (
		// When behind we will try to catch up on 5% of samples per second.
		backlogCatchup = 0.05 * dataPending
		// Calculate Time to send one sample, averaged across all sends done this tick.
		timePerSample = dataOutDuration / dataOutRate
		desiredShards = timePerSample * (dataInRate*dataKeptRatio + backlogCatchup)
	)
	t.metrics.desiredNumShards.Set(desiredShards)
	level.Debug(t.logger).Log("msg", "QueueManager.calculateDesiredShards",
		"dataInRate", dataInRate,
		"dataOutRate", dataOutRate,
		"dataKeptRatio", dataKeptRatio,
		"dataPendingRate", dataPendingRate,
		"dataPending", dataPending,
		"dataOutDuration", dataOutDuration,
		"timePerSample", timePerSample,
		"desiredShards", desiredShards,
		"highestSent", highestSent,
		"highestRecv", highestRecv,
	)

	// Changes in the number of shards must be greater than shardToleranceFraction.
	var (
		lowerBound = float64(t.numShards) * (1. - shardToleranceFraction)
		upperBound = float64(t.numShards) * (1. + shardToleranceFraction)
	)
	level.Debug(t.logger).Log("msg", "QueueManager.updateShardsLoop",
		"lowerBound", lowerBound, "desiredShards", desiredShards, "upperBound", upperBound)

	desiredShards = math.Ceil(desiredShards) // Round up to be on the safe side.
	if lowerBound <= desiredShards && desiredShards <= upperBound {
		return t.numShards
	}

	numShards := int(desiredShards)
	// Do not downshard if we are more than ten seconds back.
	if numShards < t.numShards && delay > 10.0 {
		level.Debug(t.logger).Log("msg", "Not downsharding due to being too far behind")
		return t.numShards
	}

	if numShards > t.cfg.MaxShards {
		numShards = t.cfg.MaxShards
	} else if numShards < t.cfg.MinShards {
		numShards = t.cfg.MinShards
	}
	return numShards
}
```

desiredShards = timePerSample * (dataInRate*dataKeptRatio + backlogCatchup)

```go
timePerSample = dataOutDuration / dataOutRate
backlogCatchup = 0.05 * dataPending
dataInRate      = t.dataIn.rate()
dataOutRate     = t.dataOut.rate()
dataKeptRatio   = dataOutRate / (t.dataDropped.rate() + dataOutRate)
dataOutDuration = t.dataOutDuration.rate() / float64(time.Second)
```

可以看出 desiredShards 约等于 timePerSample（每个sample所花的时间）乘以 dataInRate（输入的速率），为了更精确加入了dataDropped修正，以及dataPending修正。

# reshardLoop()

停止旧分片后启动新分片。

```go
func (t *QueueManager) reshardLoop() {
	defer t.wg.Done()

	for {
		select {
		case numShards := <-t.reshardChan:
			// We start the newShards after we have stopped (the therefore completely
			// flushed) the oldShards, to guarantee we only every deliver samples in
			// order.
			t.shards.stop()
			t.shards.start(numShards)
		case <-t.quit:
			return
		}
	}
}
```