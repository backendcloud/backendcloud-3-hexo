---
title: Dockerized Build
readmore: true
date: 2022-09-08 10:54:14
categories:
tags:
---



Why?
Current build system for KubeVirt is done inside docker. This ensures a robust and consistent build environment:

No need to install system dependencies
Controlled versions of these dependencies
Agnostic of local golang environment
So, in general, you should just use the dockerized build system.

Still, there are some drawbacks there:

Tool integration:
Since your tools are not running in the dockerized environment, they may give different outcome than the ones running in the dockerized environment
Invoking any of the dockerized scripts (under hack directory) may be inconsistent with the outside environment (e.g. file path is different than the one on your machine)
Build time: the dockerized build has some small overheads, and some improvements are still needed to make sure that caching work properly and build is optimized
And last, but not least, sometimes it is just hard to resist the tinkering…