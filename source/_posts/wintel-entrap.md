---
title: wintel DIY 入坑记
readmore: false
date: 2022-06-14 20:05:17
categories: 生活
tags:
---

最近组装了一台电脑，入了三次小坑，记录下。

# 蓝牙设备工作正常但搜不到蓝牙键盘，鼠标，耳机等设备
机箱是双层金属的，内层粗网状金属，外层细网状金属，wifi和蓝牙的波长不一样，不屏蔽wifi信号但完全屏蔽了蓝牙信号，就如同屏蔽室一样。

接了主板的天线后，就完全正常了。因为一开始能收到隔壁屋很好的wifi信号，我觉得就不用接天线了，因为天线就是起增强信号的作用，能收到很好的wifi信号就不用挂一个天线碍事。没想到wifi和蓝牙波长不一样，蓝牙完全被屏蔽了。

主板配套的天线不仅仅起增强信号的作用，还可以接收屏蔽空间以外的信号，作用等同于把机箱盖一侧打开。

# ddr5内存目前还非常不成熟

到目前为止AMD还不支持ddr5，只支持ddr4，intel 12代酷睿开始支持ddr5，但目前支持得非常不成熟。

市场上几乎还没有很好支持4个ddr插槽插满还能正常工作的主板和内存（虽然主板标配4个ddr5插槽），实际最多能支持2个。看ROG主板的兼容列表，支持上百个`16G*2`的内存型号，只支持10个以内的`32G*2`的内存型号，只支持1个`16G*4`的内存型号还是降频支持，支持0个`32G*4`内存型号。而`32G*4`在ddr4已很成熟。

目前的技术下，想cpu超频+4根ddr5内存XMP就是天方夜谭。

# hyper-v 带来的L1缓存性能断崖式下降
用测试软件测试下来电脑存储的速度和预期一致。

* 硬盘用的三星980pro，单根ssd顺序读速度七千MB每秒，顺序写速度五千MB每秒。（可以用raid0组合实现顺序读写的再翻n倍，甚至可以超过ddr5的读写速度，但硬盘随机读写很弱，即使用raid0也不能让随机读写性能得到提升，而日常使用中很多是随机读写的场景，内存擅长的是随机读写，所以不管怎样硬盘没法取代内存。内存不够扩内存不要用硬盘来补。）
* 内存用的芝奇ddr5 5600 C36-36-36-76，读写八万MB每秒。
* L3 < L2 < L1，L2 L3读写在几十万MB到一百多万MB每秒，L1缓存的速度两百万MB到四百万MB每秒。

```bash
下面是硬盘测试数据

Samsung SSD 980 PRO 1TB

[Read]
Sequential 1MiB (Q=  8, T= 1):  6835.432 MB/s [   6518.8 IOPS] <  1225.31 us>
Sequential 1MiB (Q=  1, T= 1):  3654.139 MB/s [   3484.9 IOPS] <   286.54 us>
Random 4KiB (Q= 32, T=16):  4345.706 MB/s [1060963.4 IOPS] <   481.82 us>
Random 4KiB (Q=  1, T= 1):    87.317 MB/s [  21317.6 IOPS] <    46.78 us>

[Write]
Sequential 1MiB (Q=  8, T= 1):  4998.115 MB/s [   4766.6 IOPS] <  1675.83 us>
Sequential 1MiB (Q=  1, T= 1):  3689.889 MB/s [   3519.0 IOPS] <   283.73 us>
Random 4KiB (Q= 32, T=16):  4040.302 MB/s [ 986401.9 IOPS] <   517.86 us>
Random 4KiB (Q=  1, T= 1):   282.182 MB/s [  68892.1 IOPS] <    14.44 us>

980pro对比另一块公司刚发（2022年4月）的笔记本电脑的ssd硬盘，三星980pro性能强太多。ssd不分台式机还是笔记本，只能说明品牌的电脑只会配商品介绍里提到的配置参数，不会在细节上再选配置，因为也没人在意，实际性能能拉开10多倍差距。

KXG60ZNV512G KIOXIA

[Read]
Sequential 1MiB (Q=  8, T= 1):  3250.798 MB/s [   3100.2 IOPS] <  2578.73 us>
Sequential 1MiB (Q=  1, T= 1):  2045.820 MB/s [   1951.0 IOPS] <   511.97 us>
Random 4KiB (Q= 32, T=16):   660.167 MB/s [ 161173.6 IOPS] <  1378.33 us>
Random 4KiB (Q=  1, T= 1):    39.156 MB/s [   9559.6 IOPS] <   104.33 us>

[Write]
Sequential 1MiB (Q=  8, T= 1):  2797.679 MB/s [   2668.1 IOPS] <  2989.80 us>
Sequential 1MiB (Q=  1, T= 1):  1773.235 MB/s [   1691.1 IOPS] <   590.63 us>
Random 4KiB (Q= 32, T=16):   299.802 MB/s [  73193.8 IOPS] <  4632.64 us>
Random 4KiB (Q=  1, T= 1):    73.377 MB/s [  17914.3 IOPS] <    55.62 us>
```

下面是内存和cpu缓存测试数据：
![](/images/wintel-entrap_images/86dd733d.png)

> 对比了下DDR4的测试数据，DDR4的延时还略优于DDR5，哎，频率这么高竟然延时还败了，时钟周期太多了，好在DDR5带宽达到了DDR4的两倍。

但是一旦开启了hyper-v，L1缓存的速度断崖式下跌到只有原来的10%。我也查了测试软件的论坛，也发帖了相关问题。

> https://forums.aida64.com/topic/9093-intel-12900k-l1-cache-speed/

![](/images/wintel-entrap_images/55c71134.png)
![](/images/wintel-entrap_images/992792ac.png)

> 目前只知道是hyper-v导致的现象，不知道根本原因是hyper-v导致的还是测试软件的问题，就是不知道开启了hyper-v性能是否真的下降了。多了一层Hyper-V Hypervisor，L1性能损失成这样吗？

![](/images/wintel-entrap_images/da244eba.png)

> 另外hyper-v还有一个坑，虽然网上说hyper-v和vmware可以共存，但是仅在一层硬件虚拟化上，继续嵌套虚拟化只能用Emulator，若涉及嵌套硬件虚拟化，是不能共存的。只能二选一。
 
![](/images/wintel-entrap_images/4595cde7.png)
![](/images/wintel-entrap_images/d3c24655.png)

