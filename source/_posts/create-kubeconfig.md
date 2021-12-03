---
title: 云管平台创建资源池租户功能的实现
date: 2021-09-13 14:22:18
categories: 云原生
tags:
- kubeconfig

---
`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 实现方案

Java版云管平台项目中创建资源池租户，南向接口需要对底层的Kubernetes创建namespace的同时创建同名Kubernetes用户。

对k8s apiserver的请求(kubectl客户端、客户端库或者构造REST请求来访问kubernetes API)。

Java版的Kubernetes客户端库有官方版的io.kubernetes.client以及非官方的io.fabric8.kubernetes。后者非官方的要强大于官方的，所以方案选用非官方的。但调研后发现即使非官方的也有很多接口没有实现，比如需求方案中需要用到的"kubectl config set-context"，库并没有对应但接口实现。参考github社区的讨论 https://github.com/fabric8io/kubernetes-client/issues/1512  这些接口客户端库并没有实现。所以最终代码只能采用`java`+`shell`的方式来实现，`java`负责调用库已实现的接口，库没有实现的接口交由`shell`调用`kubectl`命令。

```java
    /**
     * 更新k8s ns：没有就创建ns & quota；有就更新原ns的quota
     * @param yamlString kube config文件内容
     * @param name k8s namespace名称
     * @param quota json格式的quota信息，目前只支持cpu, memory, pods
     * @throws IOException
     */
    public static void nsCreateOrReplace(String yamlString, String name, String quota) throws IOException {
        KubernetesClient k8sClient = KubernetesClientGenerator.fromYamlStringGetKubernetesClient(yamlString);
        Namespace ns = new NamespaceBuilder().withNewMetadata().withName(name).endMetadata().build();
        k8sClient.namespaces().createOrReplace(ns);
        ResourceQuota resourceQuota = new ResourceQuotaBuilder()
                .withNewMetadata().withName("ns-quota").endMetadata()
                .withNewSpec()
                .addToHard("cpu", new Quantity("0"))
                .addToHard("memory", new Quantity("0"))
                .addToHard("pods", new Quantity("0"))
                .endSpec().build();
        k8sClient.resourceQuotas().inNamespace(name).createOrReplace(resourceQuota);
        if (quota == null) {return;}
        Gson gson = new Gson();
        ListVDCDetailResponse.PoolTenantsDTO.QuotaSpecDTO quotaSpec = gson.fromJson(quota, ListVDCDetailResponse.PoolTenantsDTO.QuotaSpecDTO.class);
//        if (cpu == null) {cpu = 0;}
//        if (memory == null) {memory = 0;}
//        if (pods ==  null) {pods = 0;}
        if (quotaSpec == null) {return;}
        resourceQuota = new ResourceQuotaBuilder()
                .withNewMetadata().withName("ns-quota").endMetadata()
                .withNewSpec()
                .addToHard("cpu", new Quantity(quotaSpec.getCpu().toString()))
                .addToHard("memory", new Quantity(quotaSpec.getMemory().toString()))
                .addToHard("pods", new Quantity(quotaSpec.getPods().toString()))
                .endSpec().build();
        k8sClient.resourceQuotas().inNamespace(name).createOrReplace(resourceQuota);
    }
```

```java
    public static void nsDelete(String yamlString, String name) throws IOException {
        KubernetesClient k8sClient = KubernetesClientGenerator.fromYamlStringGetKubernetesClient(yamlString);
        Namespace ns = new NamespaceBuilder().withNewMetadata().withName(name).endMetadata().build();
        k8sClient.namespaces().delete(ns);
    }
```

```java
    public static String createKubeConfig(String cluster, String namespace) throws IOException {
        File file = new File("/etc/cmp/kubeconfig/create-kubeconfig.sh");
        if(file.exists()) {
            String tt = "/etc/cmp/kubeconfig/create-kubeconfig.sh " + cluster + " " + namespace + " 2>&1";
            String[] cmd = new String[] { "/bin/bash", "-c", tt};
            Process ps = Runtime.getRuntime().exec(cmd);
            BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
            StringBuffer sb = new StringBuffer();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            String result = sb.toString();
            log.debug(tt);
            log.debug(result);
            String configFilePath = "/etc/cmp/kubeconfig/" + cluster + "/" + namespace + ".config";
            File configFile = new File(configFilePath);
            if(configFile.exists()) {
                BufferedReader in = new BufferedReader(new FileReader(configFilePath));
                String str;
                StringBuffer sb2 = new StringBuffer();
                while ((str = in.readLine()) != null) {
                    sb2.append(str).append("\n");
                }
                String result2 = sb2.toString();
                log.debug("kube config:");
                log.debug(result2);
                return result2;
            }
        }
        return null;
    }
```

```java
    public static void deleteKubeConfig(String cluster, String namespace) throws IOException {
        File file = new File("/etc/cmp/kubeconfig/delete-kubeconfig.sh");
        if(file.exists()) {
            String[] cmd = new String[] { "/bin/bash", "-c", "/etc/cmp/kubeconfig/delete-kubeconfig.sh " + cluster + " " + namespace};
            Process ps = Runtime.getRuntime().exec(cmd);
            BufferedReader br = new BufferedReader(new InputStreamReader(ps.getInputStream()));
            StringBuffer sb = new StringBuffer();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            String result = sb.toString();
            log.info(result);
        }
    }
```

上面四个函数分别实现的功能是：创建ns，删除ns，创建kubeconfig，删除kubeconfig。

创建删除kubeconfig的java程序中调用两个shell脚本`create-kubeconfig.sh`和`delete-kubeconfig.sh`分别用于创建和删除kubeconfig。


```bash
# cat create-kubeconfig.sh
set -v
[[ $# -ne 2 ]] && usage

mkdir -p /etc/cmp/kubeconfig/$1/
cd /etc/cmp/kubeconfig/$1/
openssl genrsa -out $2.key 2048
openssl req -new -key $2.key -out $2.csr -subj "/CN=$2/O=$2"
openssl x509 -req -in $2.csr -CA kubernetes/ca.crt -CAkey kubernetes/ca.key -CAcreateserial -out $2.crt -days 36500
kubectl config set-credentials $2 --client-certificate=$2.crt  --client-key=$2.key
kubectl config set-context $2 --cluster=$1 --namespace=$2 --user=$2
kubectl config view --flatten --merge --minify --context $2 > $2.config
#kubectl create ns $2

cat>$2-rolebinding.yaml<<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $2-rolebinding
  namespace: $2
subjects:
- kind: User
  name: $2
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: admin
  apiGroup: ""
EOF

kubectl apply -f $2-rolebinding.yaml

usage(){
	echo "Usage: $0 <cluster-name> <namespace-name>"
	exit 1
}
```

```bash
# cat delete-kubeconfig.sh
set -v
if [ $# -ne 2 ];
then
    exit
fi

cd /etc/cmp/kubeconfig/$1/
kubectl delete -f $2-rolebinding.yaml
kubectl config delete-context $2
kubectl config delete-user $2
rm -rf $2-rolebinding.yaml $2.config $2.key $2.crt $2.csr
#kubectl delete ns $2
```

`create-kubeconfig.sh`实现的功能是`创建用户凭证和创建角色`和`角色权限绑定`，delete-kubeconfig.sh就是反过来：`解绑`和`删除凭证`。下面详细讲述`create-kubeconfig.sh`中的`创建用户凭证和创建角色`和`角色权限绑定`。

## 创建用户凭证

Kubernetes没有 User Account 的 API 对象，要创建一个用户帐号，利用管理员分配的一个私钥就可以创建了，参考官方文档中的方法，用OpenSSL证书来创建一个 User，也可以使用更简单的cfssl工具来创建：

给用户 xxx 创建一个私钥，命名成：xxx.key：

$ openssl genrsa -out xxx.key 2048

使用刚刚创建的私钥创建一个证书签名请求文件：xxx.csr，要注意需要确保在-subj参数中指定用户名和组(CN表示用户名，O表示组)：

$ openssl req -new -key xxx.key -out xxx.csr -subj "/CN=xxx/O=xxx"

然后找到Kubernetes集群的CA，若使用kubeadm安装的集群，CA相关证书位于/etc/kubernetes/ssl/目录下面，若是二进制方式搭建的，在最开始搭建集群的时候就已经指定好了CA的目录，利用该目录下面的ca.crt和ca.key两个文件来批准上面的证书请求

生成最终的证书文件，我们这里设置证书的有效期为500天：

$ openssl x509 -req -in xxx.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out xxx.crt -days 500

现在查看当前文件夹下面是否生成了一个证书文件：

$ ls
xxx.csr xxx.key xxx.crt

现在可以使用刚刚创建的证书文件和私钥文件在集群中创建新的凭证和上下文(Context):

$ kubectl config set-credentials xxx --client-certificate=xxx.crt  --client-key=xxx.key

可以看到一个用户xxx创建了，然后为这个用户设置新的 Context:

$ kubectl config set-context xxx --cluster=kubernetes --namespace=kube-system --user=xxx

到这里，用户haimaxy就已经创建成功了，现在使用当前的这个配置文件来操作kubectl命令的时候，应该会出现错误，因为还没有为该用户定义任何操作的权限呢：

$ kubectl get pods --context=xxx
Error from server (Forbidden): pods is forbidden: User "xxx" cannot list pods in the namespace “default"

## 创建角色和角色权限绑定

Role 和 ClusterRole：角色和集群角色，这两个对象都包含上面的 Rules 元素，二者的区别在于，在 Role 中，定义的规则只适用于单个命名空间，也就是和 namespace 关联的，而 ClusterRole 是集群范围内的，因此定义的规则不受命名空间的约束。

用户创建完成后，接下来就需要给该用户添加操作权限，我们来定义一个YAML文件，创建一个允许用户操作 Deployment、Pod、ReplicaSets 的角色，如下定义：(xxx-role.yaml)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: xxx-role
  namespace: kube-system
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # 也可以使用['*']
```

其中Pod属于 core 这个 API Group，在YAML中用空字符就可以，而Deployment属于 apps 这个 API Group，ReplicaSets属于extensions这个 API Group，所以 rules 下面的 apiGroups 就综合了这几个资源的 API Group：[“”, “extensions”, “apps”]，其中verbs可以对这些资源对象执行的操作，需要所有的操作方法，也可以使用[’*‘]来代替。

然后创建这个Role：

$ kubectl create -f xxx-role.yaml

注意这里没有使用上面的xxx这个上下文了，因为没权限

Role 创建完成了，这个 Role 和用户 xxx 还没有任何关系，需要创建一个RoleBinding对象，在 kube-system 这个命名空间下面将上面的 xxx-role 角色和用户 xxx 进行绑定:(xxx-rolebinding.yaml)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: xxx-rolebinding
  namespace: kube-system
subjects:
- kind: User
  name: xxx
  apiGroup: ""
roleRef:
  kind: Role
  name: xxx-role
  apiGroup: “"
```

上面的YAML文件中的subjects关键字就是上面提到的用来尝试操作集群的对象，这里对应上面的 User 帐号 xxx，使用kubectl创建上面的资源对象：

$ kubectl create -f xxx-rolebinding.yaml

测试

现在应该可以上面的xxx上下文来操作集群了：

$ kubectl get pods --context=xxx
….

可以看到使用kubectl的使用并没有指定 namespace ，这是因为我们已经为该用户分配了权限了，可以查看到分配的namespace中的所有pod，如果我们在后面加上一个-n default

$ kubectl --context=xxx-context get pods --namespace=default
Error from server (Forbidden): pods is forbidden: User "xxx" cannot list pods in the namespace "default"
是符合预期的。因为该用户并没有 default 这个命名空间的操作权限

# 参考

针对需求本方案采用的是shell脚本实现主要功能，若客户端具备相应接口调用的功能，还是能用java客户端库尽量用库来实现，下面是调研的几个需求相关的库的实现。

## 参考：kubectl客户端以及库操作context的example

### 更换context

```java
import io.fabric8.kubernetes.api.model.ObjectMeta;
import io.fabric8.kubernetes.api.model.Pod;
import io.fabric8.kubernetes.client.Config;
import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Java equivalent of `kubectl config use-context my-cluster-name`. You can specify a different
 * context before creating the client(which may be different from current context in your KubeConfig).
 * Changing context after creation of client is not supported right now: https://github.com/fabric8io/kubernetes-client/issues/1512
 */
public class ConfigUseContext {
  private static final Logger logger = LoggerFactory.getLogger(ConfigUseContext.class);


  public static void main(String[] args) {
    // Pass the context you want to use in Config.autoConfigure(..)
    Config config = Config.autoConfigure( "minikube");
    // Use modified Config for your operations with KubernetesClient
    try (final KubernetesClient k8s = new DefaultKubernetesClient(config)) {
      k8s.pods().inNamespace("default").list().getItems().stream()
        .map(Pod::getMetadata)
        .map(ObjectMeta::getName)
        .forEach(logger::info);
    }
  }
}
```


### 查看当前的context

```java
import io.fabric8.kubernetes.api.model.NamedContext;
import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import io.fabric8.kubernetes.client.KubernetesClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * This is Java equivalent of `kubectl config current-context`
 */
public class ConfigGetCurrentContextEquivalent {
  private static final Logger logger = LoggerFactory.getLogger(ConfigGetCurrentContextEquivalent.class);


  public static void main(String[] args) {
    try (final KubernetesClient k8s = new DefaultKubernetesClient()) {
      NamedContext currentContext = k8s.getConfiguration().getCurrentContext();
      logger.info("Current Context: {}", currentContext.getName());
    }
  }
}
```


### 获取当前context的完整的kubeconfig内容的命令
kubectl config view --minify --flatten —merge


获取kubeconfig的客户端库代码

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;


/**
 * Java equivalent of `kubectl config view`. Prints KubeConfig contents
 */
public class ConfigViewEquivalent {
  private static final Logger logger = LoggerFactory.getLogger(ConfigViewEquivalent.class);


  public static void main(String[] args) throws IOException {
    // Gets KubeConfig via reading KUBECONFIG environment variable or ~/.kube/config
    String kubeConfigFileName = io.fabric8.kubernetes.client.Config.getKubeconfigFilename();
    if (kubeConfigFileName != null) {
      File kubeConfigFile = new File(kubeConfigFileName);
      Files.readAllLines(kubeConfigFile.toPath())
        .forEach(logger::warn);
    }
  }
}
```

## 参考：为用户添加基于角色的访问控制(RBAC)

### 角色(Role)
在RBAC中，角色有两种——普通角色(Role)和集群角色(ClusterRole)，ClusterRole是特殊的Role，相对于Role来说：
* Role属于某个命名空间，而ClusterRole属于整个集群，其中包括所有的命名空间
* ClusterRole能够授予集群范围的权限，比如node资源的管理，比如非资源类型的接口请求(如"/healthz")，比如可以请求全命名空间的资源(通过指定 --all-namespaces)

###为用户添加角色

首先创造一个角色

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: a-1
  name: admin
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
```

这是在a-1命名空间内创建了一个admin管理员角色，这里只是用admin角色举例，实际上如果只是为了授予用户某命名空间管理员的权限的话，是不需要新建一个角色的，K8S已经内置了一个名为admin的ClusterRole

### 将角色和用户绑定

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: admin-binding
  namespace: a-1
subjects:
- kind: User
  name: tom
  apiGroup: ""
roleRef:
  kind: Role
  name: admin
  apiGroup: ""
```

如yaml中所示，RoleBinding资源创建了一个 Role-User 之间的关系，roleRef节点指定此RoleBinding所引用的角色，subjects节点指定了此RoleBinding的受体，可以是User，也可以是前面说过的ServiceAccount，在这里只包含了名为 tom 的用户

### 添加命名空间管理员的另一种方式

前面说过，K8S内置了一个名为admin的ClusterRole，所以实际上我们无需创建一个admin Role，直接对集群默认的admin ClusterRole添加RoleBinding就可以了

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: admin-binding
  namespace: a-1
subjects:
- kind: User
  name: tom
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: admin
  apiGroup: ""
```

这里虽然引用的是作为ClusterRole的admin角色，但是其权限被限制在RoleBinding admin-binding所处的命名空间，即a-1内
如果想要添加全命名空间或者说全集群的管理员，可以使用cluster-admin角色
到此为止，我们已经：
* 为tom用户提供了基于X509证书的验证
* 为a-1命名空间创造了一个名为admin的角色
* 为用户tom和角色admin创建了绑定关系

