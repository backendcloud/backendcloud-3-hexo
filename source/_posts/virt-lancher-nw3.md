---
title: KubeVirt网络源码分析（3）- 虚拟机热迁移网络
readmore: true
date: 2022-05-30 18:30:24
categories: KubeVirt
tags:
- KubeVirt
- virt-lancher
- 网络
---

热迁移的流程非常复杂，本篇仅设计热迁移的数据走的网络相关部分。

# 操作 - 热迁移的网络

虚拟机热迁移过程中很占用带宽，对网络稳定性要求也较高。为和可以原有的Kubernetes网络互不影响，生产环境最好有一套独立的网络给虚拟机热迁移使用。

这就意味着，每个Kubernetes工作节点至少要有两张网卡，所有用于热迁移的网口需要通过交换机实现互通。下面的例子将热迁移的网卡命名为eth1。

首先需要Kubernetes CNI multus 和 ipam whereabouts已经安装好。创建一个NetworkAttachmentDefinition。
```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: migration-network
  namespace: kubevirt
spec:
  config: '{
      "cniVersion": "0.3.1",
      "name": "migration-bridge",
      "type": "macvlan",
      "master": "eth1",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "10.1.1.0/24"
      }
    }'
```
配置KubeVirt虚拟机热迁移流量走上面定义的独立网口。
```yaml
apiVersion: kubevirt.io/v1
kind: Kubevirt
metadata:
  name: kubevirt
  namespace: kubevirt
spec:
  configuration:
    developerConfiguration:
      featureGates:
      - LiveMigration
    migrations:
      network: migration-network
```

```bash
build@jed:~/kubevirt$ kubectl get vmis                                                                                                                                     
NAME             AGE   PHASE     IP               NODENAME   READY                                                                                                         
vmi-migratable   38s   Running   10.244.196.145   node01     True                                                                                                          
build@jed:~/kubevirt$ kubectl get vmis                                                                                                                                     
NAME             AGE   PHASE     IP              NODENAME   READY                                                                                                          
vmi-migratable   41s   Running   10.244.140.88   node02     False
build@jed:~/kubevirt$ kubectl get vmis -o yaml                                                                                                                             
```
```yaml
      targetDirectMigrationNodePorts:                                                                                                                                      
        "32899": 0                                                                                                                                                         
        "39497": 49153                                                                                                                                                     
        "42691": 49152                                                                                                                                                     
      targetNode: node02                                                                                                                                                   
      targetNodeAddress: 10.1.1.1                                                                                                                                          
      targetNodeDomainDetected: true                                                                                                                                       
      targetPod: virt-launcher-vmi-migratable-llcq5                                                                                                                        
    migrationTransport: Unix                                                                                                                                               
    nodeName: node02                                                                                                                                                       
    phase: Running 
```

# livvirt remote url

libvirt remote url格式如下：

    driver[+transport]://[username@][hostname][:port]/[path][?extraparameters]

# KubeVirt 源码分析 - 热迁移的网络

virt-handler 会判断当前的virt-hander所在node是热迁移的源节点还是目的节点，若是源节点，就开启源节点的proxy，若是目的节点，就开启目的节点的proxy。
```go
	if d.isPreMigrationTarget(vmi) {
		return d.vmUpdateHelperMigrationTarget(vmi)
	} else if d.isMigrationSource(vmi) {
		return d.vmUpdateHelperMigrationSource(vmi)
	} else {
		return d.vmUpdateHelperDefault(vmi, domainExists)
	}
```

## 若vmi的迁移状态不为空，vmi的源节点就是当前节点，目的节点不为空，迁移未完成，则进入热迁移的源节点准备流程`handleSourceMigrationProxy`
```go
func (d *VirtualMachineController) isMigrationSource(vmi *v1.VirtualMachineInstance) bool {

	if vmi.Status.MigrationState != nil &&
		vmi.Status.MigrationState.SourceNode == d.host &&
		vmi.Status.MigrationState.TargetNodeAddress != "" &&
		!vmi.Status.MigrationState.Completed {

		return true
	}
	return false

}
```

```go
// Source proxy exposes a unix socket server and pipes to an outbound TCP connection.
func NewSourceProxy(unixSocketPath string, tcpTargetAddress string, serverTLSConfig *tls.Config, clientTLSConfig *tls.Config, vmiUID string) *migrationProxy {
	return &migrationProxy{
		unixSocketPath:  unixSocketPath,
		targetAddress:   tcpTargetAddress,
		targetProtocol:  "tcp",
		stopChan:        make(chan struct{}),
		fdChan:          make(chan net.Conn, 1),
		listenErrChan:   make(chan error, 1),
		serverTLSConfig: serverTLSConfig,
		clientTLSConfig: clientTLSConfig,
		logger:          log.Log.With("uid", vmiUID).With("listening", filepath.Base(unixSocketPath)).With("outbound", tcpTargetAddress),
	}
}
```

代码片段1：该代码是共通的方法，源节点proxy调用的时候，走的是 createUnixListener 分支
```go
func (m *migrationProxy) Start() error {

	if m.unixSocketPath != "" {
		err := m.createUnixListener()
		if err != nil {
			return err
		}
	} else {
		err := m.createTcpListener()
		if err != nil {
			return err
		}
	}

	go func(ln net.Listener, fdChan chan net.Conn, listenErr chan error, stopChan chan struct{}) {
		for {
			fd, err := ln.Accept()
			if err != nil {
				listenErr <- err

				select {
				case <-stopChan:
					// If the stopChan is closed, then this is expected. Log at a lesser debug level
					m.logger.Reason(err).V(3).Infof("stopChan is closed. Listener exited with expected error.")
				default:
					m.logger.Reason(err).Error("proxy unix socket listener returned error.")
				}
				break
			} else {
				fdChan <- fd
			}
		}
	}(m.listener, m.fdChan, m.listenErrChan, m.stopChan)

	go func(m *migrationProxy) {
		for {
			select {
			case fd := <-m.fdChan:
				go m.handleConnection(fd)
			case <-m.stopChan:
				return
			case <-m.listenErrChan:
				return
			}
		}

	}(m)

	m.logger.Infof("proxy started listening")
	return nil
}
```

代码片段2：该代码是共通的方法，热迁移源节点proxy调用的时候,from outbound connection to proxy,from proxy to outbound connection(POD ENV(migration unix socket) <-> HOST ENV (tcp client))
```go
func (m *migrationProxy) handleConnection(fd net.Conn) {
	defer fd.Close()

	outBoundErr := make(chan error, 1)
	inBoundErr := make(chan error, 1)

	var conn net.Conn
	var err error
	if m.targetProtocol == "tcp" && m.clientTLSConfig != nil {
		conn, err = tls.Dial(m.targetProtocol, m.targetAddress, m.clientTLSConfig)
	} else {
		conn, err = net.Dial(m.targetProtocol, m.targetAddress)
	}
	if err != nil {
		m.logger.Reason(err).Error("unable to create outbound leg of proxy to host")
		return
	}

	go func() {
		//from outbound connection to proxy
		n, err := io.Copy(fd, conn)
		m.logger.Infof("%d bytes copied outbound to inbound", n)
		inBoundErr <- err
	}()
	go func() {
		//from proxy to outbound connection
		n, err := io.Copy(conn, fd)
		m.logger.Infof("%d bytes copied from inbound to outbound", n)
		outBoundErr <- err
	}()

	select {
	case err = <-outBoundErr:
		if err != nil {
			m.logger.Reason(err).Errorf("error encountered copying data to outbound connection")
		}
	case err = <-inBoundErr:
		if err != nil {
			m.logger.Reason(err).Errorf("error encountered copying data into inbound connection")
		}
	case <-m.stopChan:
		m.logger.Info("stop channel terminated proxy")
	}
}
```

## 若vmi的目的节点就是当前节点，vmi的目的节点和源节点不是同一个节点目的节点不为空，则进入热迁移的目的节点准备流程`handleTargetMigrationProxy`
```go
func (d *VirtualMachineController) isPreMigrationTarget(vmi *v1.VirtualMachineInstance) bool {

	migrationTargetNodeName, ok := vmi.Labels[v1.MigrationTargetNodeNameLabel]

	if ok &&
		migrationTargetNodeName != "" &&
		migrationTargetNodeName != vmi.Status.NodeName &&
		migrationTargetNodeName == d.host {
		return true
	}

	return false
}
```

```go
// Target proxy listens on a tcp socket and pipes to a libvirtd unix socket
func NewTargetProxy(tcpBindAddress string, tcpBindPort int, serverTLSConfig *tls.Config, clientTLSConfig *tls.Config, libvirtdSocketPath string, vmiUID string) *migrationProxy {
	return &migrationProxy{
		tcpBindAddress:  tcpBindAddress,
		tcpBindPort:     tcpBindPort,
		targetAddress:   libvirtdSocketPath,
		targetProtocol:  "unix",
		stopChan:        make(chan struct{}),
		fdChan:          make(chan net.Conn, 1),
		listenErrChan:   make(chan error, 1),
		serverTLSConfig: serverTLSConfig,
		clientTLSConfig: clientTLSConfig,
		logger:          log.Log.With("uid", vmiUID).With("outbound", filepath.Base(libvirtdSocketPath)),
	}

}
```

代码片段1：该代码是共通的方法，热迁移目的节点proxy调用的时候，走的是 createTcpListener 分支

代码片段2：该代码是共通的方法，热迁移源节点proxy调用的时候,from outbound connection to proxy,from proxy to outbound connection(HOST ENV (tcp server) <-> TARGET POD ENV (libvirtd unix socket))

# 上面代码的结构如下：
SRC POD ENV(migration unix socket) <-> HOST ENV (tcp client) <-----> HOST ENV (tcp server) <-> TARGET POD ENV (libvirtd unix socket)

# 参考 - golang unix domain socket server&client
## server
```go
package main

import (
	"log"
	"net"
	"os"
)

const SockAddr = "/tmp/echo.sock"

//func echoServer(c net.Conn) {
//	log.Printf("Client connected [%s]", c.RemoteAddr().Network())
//	io.Copy(c, c)
//	c.Close()
//}

func echoServer(c net.Conn) {
	for {
		buf := make([]byte, 512)
		nr, err := c.Read(buf)
		if err != nil {
			return
		}

		data := buf[0:nr]
		println("Server got:", string(data))
		_, err = c.Write(data)
		if err != nil {
			log.Fatal("Write: ", err)
		}
	}
}

func main() {
	if err := os.RemoveAll(SockAddr); err != nil {
		log.Fatal(err)
	}
	l, err := net.Listen("unix", SockAddr)
	if err != nil {
		log.Fatal("listen error:", err)
	}

	for {
		fd, err := l.Accept()
		if err != nil {
			log.Fatal("accept error:", err)
		}

		go echoServer(fd)
	}
}
```

## client
```go
package main

import "net"
import "time"

func main() {
	c, err := net.Dial("unix", "/tmp/echo.sock")
	if err != nil {
		panic(err)
	}
	for {
		_, err := c.Write([]byte("hi\n"))
		if err != nil {
			println(err)
		}
		time.Sleep(1e9)
	}
}
```