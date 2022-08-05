```bash
 ⚡ root@centos9  ~/origin/kubevirt   release-0.53 ±  tree _out
_out
├── cmd
│   ├── cluster-profiler
│   │   └── cluster-profiler
│   ├── dump
│   │   └── dump
│   ├── perfscale-audit
│   │   └── perfscale-audit
│   ├── perfscale-load-generator
│   │   └── perfscale-load-generator
│   └── virtctl
│       ├── virtctl
│       ├── virtctl-v0.53.2-43-g8772b261b-darwin-amd64
│       ├── virtctl-v0.53.2-43-g8772b261b-linux-amd64
│       └── virtctl-v0.53.2-43-g8772b261b-windows-amd64.exe
├── digests
│   └── bazel-bin
│       ├── push-conformance.digest
│       ├── push-libguestfs.digest
│       ├── push-virt-api.digest
│       ├── push-virt-controller.digest
│       ├── push-virt-handler.digest
│       ├── push-virt-launcher.digest
│       └── push-virt-operator.digest
├── manifests
│   ├── release
│   │   ├── conformance.yaml
│   │   ├── demo-content.yaml
│   │   ├── kubevirt-cr.yaml
│   │   ├── kubevirt-operator.yaml
│   │   └── olm
│   │       ├── bundle
│   │       │   ├── kubevirt-crds.yaml
│   │       │   ├── kubevirtoperator.vmybuild7.clusterserviceversion.yaml
│   │       │   └── kubevirt-package.yaml
│   │       ├── kubevirt-csv-preconditions.yaml
│   │       ├── kubevirt-operatorsource.yaml
│   │       ├── kubevirt-subscription.yaml
│   │       └── operatorgroup.yaml
│   └── testing
│       ├── disks-images-provider.yaml
│       ├── rbac-for-testing.yaml
│       └── uploadproxy-nodeport.yaml
├── templates
│   └── manifests
│       ├── release
│       │   └── olm
│       │       └── bundle
│       └── testing
└── tests
    └── tools
        └── manifest-templator

21 directories, 30 files
```


```bash
 ✘ ⚡ root@backendcloud  ~/example/bazel-sample/docker   master ±  make docker-push
bazel run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
INFO: Analyzed target //cmd:image-push (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //cmd:image-push up-to-date:
  bazel-bin/cmd/image-push.digest
  bazel-bin/cmd/image-push
INFO: Elapsed time: 0.209s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/08/04 16:40:55 Error pushing image to 100.73.54.12:80/backendcloud/bazel-sample-cmd:v1.0.0: unable to push image to 100.73.54.12:80/backendcloud/bazel-sample-cmd:v1.0.0: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
make: *** [Makefile:2: docker-push] Error 1
```