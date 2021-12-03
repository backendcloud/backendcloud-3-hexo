---
title: 在产品开发中调用Kubernetes API接口遇到的几个问题
date: 2021-09-28 17:25:28
categories: 云原生
tags:
- Kubernetes API
- 云原生
- 中心云
- 边缘云
- 边缘计算

---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

URL切换，产品提供一个功能就是透传Kuernetes API接口调用，就是要把对`https://xx.xx.xx.xx:xx/api/v1/xx/xx/yy/../zz`接口的调用变成对`https://<kubernetes-ip>:6443/yy/../zz`接口（Kubernetes原生接口的调用），开发过程中遇到了一些问题，记录一下。

# 思路和过程：
* `step1`部署Kubernetes，Kubernetes的master节点放在中心云上，worker节点放在边缘云上。中心云的master和边缘云的worker都不通公网，软件部署在有公网的云主机上，软件所在云主机不通master节点，但是可以通worker节点。现在想通过配置代理转发，可以通过访问软件部署的节点的公网去调用Kubernetes接口。
* `step1`的代理转发，有5种方案可供选择。`方案1`: ssh隧道转发。`方案2`: Iptables NAT转发。`方案3`: Firewalld NAT转发。`方案4`: Haproxy转发。`方案5`: nginx代理。采用最简单的`方案1`实现公网上的任何一台机器和Kubernetes的API网络可达。
* `step1`的代理转发遇到问题1：不通过代理转发https SSL认证没问题，代理转发后出现了https SSL认证问题。
* `step2`转换url。转换url有两个可选方案（`方案6`: nginx url映射。`方案7`: Spring redirect）
* `step2`中的`方案7`相对`方案6`更简单，不需要部署nginx和配置nginx，用几句java代码即可实现。选用`方案7`。
* `step2`中遇到了`问题2`:  调用Kuernetes API需要携带token，但是调用产品的接口想把token拿掉
* 解决`问题2`采用`方案8`： 拦截器修改header，添加token字段。失败，记录为`问题3`。采用`方案9`: kubectl proxy，`方案9`解决`问题3`，不需要携带token字段
* `方案9`带来了2个问题，本地kubectl proxy有效，其他机器kubectl proxy无效，记录为`问题4`。
* 采用`方案7`的过程中遇到了`问题5`: GET请求 redirect没有问题，但是POST请求redirect失败

下面详细说明下采到到三个方案：`方案1`，`方案7`，`方案9` 和 `问题1～5`。其他未采用的方案读者可自行网上搜索。

# 方案1: ssh隧道本地道转发

## ssh隧道本地转发介绍
如下图，假如host3和host1、host2都同互相通信，但是host1和host2之间不能通信，如何从host1连接上host2？

对于实现ssh连接来说，实现方式很简单，从host1 ssh到host3，再ssh到host2，也就是将host3作为跳板的方式。但是如果不是ssh，而是http的80端口呢？如何让host1能访问host2的80端口？

![](/images/kubernetes-api/1.jpeg)

ssh支持本地端口转发，语法格式为：

	ssh -L [local_bind_addr:]local_port:remote:remote_port middle_host

以上图为例，实现方式是在host1上执行：

	ssh -g -L 2222:host2:80 host3

其中"-L"选项表示本地端口转发，其工作方式为：在本地指定一个由ssh监听的转发端口(2222)，将远程主机的端口(host2:80)映射为本地端口(2222)，当有主机连接本地映射端口(2222)时，本地ssh就将此端口的数据包转发给中间主机(host3)，然后host3再与远程主机的端口(host2:80)通信。

现在就可以通过访问host1的2222端口来达到访问host2:80的目的了。

再来解释下"-g"选项，指定该选项表示允许外界主机连接本地转发端口(2222)，如果不指定"-g"，则host4将无法通过访问host1:2222达到访问host2:80的目的。甚至，host1自身也不能使用172.16.10.5:2222，而只能使用localhost:2222或127.0.0.1:2222这样的方式达到访问host2:80的目的，之所以如此，是因为本地转发端口默认绑定在回环地址上。可以使用bind_addr来改变转发端口的绑定地址，例如：

	# ssh -L 172.16.10.5:2222:host2:80 host3

这样，host1自身就能通过访问172.16.10.5:2222的方式达到访问host2:80的目的。

一般来说，使用转发端口，都建议同时使用"-g"选项，否则将只有自身能访问转发端口。

## 具体方案

![](/images/kubernetes-api/2.jpeg)

遇到一个问题，上面的命令就是需要一个终端窗口一直开着，或者终端软件一直开着，可以用nohup 放在服务器后台执行，为了防止ssh被中断，可以加个参数`-N`，以及修改执行nohup命令的节点的ssh_config文件

	nohup ssh -N -g -L 33023:192.168.22.32:6443 183.207.130.11 -p22 &

`183.207.130.11` 上图边缘云的worker节点ip

`192.168.22.32` 上图中心云的master节点ip

这样就可以让连上公网的任何位置的机器可以直接访问中心云+边缘云部署的Kubernetes API，访问https://<部署软件的云主机的ip>:33023等同于内部访问https://192.168.22.32:6443

修改/etc/ssh/ssh_config文件
添加一行参数
ServerAliveInterval 12

# 方案7: Spring redirect 
```java
@Slf4j
@Controller
@RequestMapping(value = "/api/v1/xxx/tenants/{tenantId}/vdcs/{vdcId}/k8s/clusters/{poolId}/", produces ="application/json;charset=UTF-8")
@Validated
@RequiresAuthentication
@Transactional
public class PassThroughController {

    private OrgService orgService;

    @Autowired
    public void setService(OrgService orgService) {
        this.orgService = orgService;
    }

    private ProjectService projectService;

    @Autowired
    public void setService(ProjectService projectService) {
        this.projectService = projectService;
    }

    private PoolTenantService poolTenantService;

    @Autowired
    public void setService(PoolTenantService poolTenantService) {
        this.poolTenantService = poolTenantService;
    }

    private K8SService k8sService;

    @Autowired
    public void setService(K8SService k8sService) {
        this.k8sService = k8sService;
    }


    /**
     * Kubernetes原生api透传接口
     * @param tenantId
     * @param vdcId
     * @param poolId
     * @param response
     * @throws IOException
     * @throws ServletException
     */
    @RequestMapping("/**")
    public RedirectView passThrough(@PathVariable String tenantId,
                            @PathVariable String vdcId,
                            @PathVariable String poolId,
                            HttpServletRequest request,
                            HttpServletResponse response) throws IOException, ServletException {

        // url是含id的格式
        if(orgService.selectById(tenantId) == null) {
            throw new BadRequestException("tenantId not found!");
        }
        if(projectService.selectById(vdcId) == null) {
            throw new BadRequestException("vdcId not found!");
        }
        if(k8sService.selectById(poolId) == null) {
            throw new BadRequestException("poolId not found!");
        }

        String url = request.getRequestURL().toString();
        String[] segments = url.split("/");
        String[] newSegments = Arrays.copyOfRange(segments, 13, segments.length);
        String newUrl = String.join("/", newSegments);
        request.setAttribute(View.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
        return new RedirectView("http://<软件部署所在的ip>:33024/"+ newUrl);
    }

}
```

# 方案8: 拦截器修改header，添加token字段。
```java
/**
 * 拦截器配置
 */
@Configuration
public class FilterConfig {

    @Bean
    public FilterRegistrationBean modifyParametersFilter() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(new ModifyParametersFilter());
        registration.addUrlPatterns("/*");              // 拦截路径
        registration.setName("modifyParametersFilter"); // 拦截器名称
        registration.setOrder(1);                       // 顺序
        return registration;
    }

    /**
     * 自定义拦截器
     */
    class ModifyParametersFilter extends OncePerRequestFilter {
        @Override
        protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
            // 修改请求头
            Map<String, String> map = new HashMap<>();
            String token2 = "bearer eyJhbGciOiJSUzI1NiIsImtpZCd1Q1QzdTSEYtZU1EM3lqb19LUVJfNm9EY0FyMjI0U0ZhY2RvYnMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tOThiZDciLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImQ4N2U0NzM4LTQ5MzUtNDQxYS05M2Y1LTgzNzUyOGMzNjcwZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.fhmRUpii4cOFU3ho2XYi1nLsxWMGDHEkS2ZY5RWJB34N40VrycSsq65V5GOOxMObpkn1wqVy2o9vFYTewoZ9FyRmmurnvbxgO2tE6367JQdGrBp0miXaRbF1XRV6eDnoEskoLTJWbKmhLIaTvl9Qg-WGzKLP-tWstO8mYwsEtwja7dBIoRhJE9PW5kQDYP60s9Xwu-oEv9zecXmKeHtoI29nLZ7oUimmNlPpmOqvMlj4BO-gGeiwl3Dkigo28hm9-L5cVM3V-TXwRymK3gFA_oTIFdw_3aMqkgMZxR6QC4cUrziIawlKHb1YDLVwMUeEPwrgb8iU0v3qzxYfQEC9-A";
            map.put("Authorization", token2);
            modifyHeaders(map, request);

            // 修改cookie
            ModifyHttpServletRequestWrapper requestWrapper = new ModifyHttpServletRequestWrapper(request);
            String token = request.getHeader("token");
            if (token != null && !"".equals(token)) {
                requestWrapper.putCookie("SHIROSESSIONID", token);
            }

            // finish
            filterChain.doFilter(requestWrapper, response);
        }
    }

    /**
     * 修改请求头信息
     * @param headerses
     * @param request
     */
    private void modifyHeaders(Map<String, String> headerses, HttpServletRequest request) {
        if (headerses == null || headerses.isEmpty()) {
            return;
        }
        Class<? extends HttpServletRequest> requestClass = request.getClass();
        try {
            Field request1 = requestClass.getDeclaredField("request");
            request1.setAccessible(true);
            Object o = request1.get(request);
            Field coyoteRequest = o.getClass().getDeclaredField("coyoteRequest");
            coyoteRequest.setAccessible(true);
            Object o1 = coyoteRequest.get(o);
            Field headers = o1.getClass().getDeclaredField("headers");
            headers.setAccessible(true);
            MimeHeaders o2 = (MimeHeaders)headers.get(o1);
            for (Map.Entry<String, String> entry : headerses.entrySet()) {
                o2.removeHeader(entry.getKey());
                o2.addValue(entry.getKey()).setString(entry.getValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 修改cookie信息
     */
    class ModifyHttpServletRequestWrapper extends HttpServletRequestWrapper {
        private Map<String, String> mapCookies;
        ModifyHttpServletRequestWrapper(HttpServletRequest request) {
            super(request);
            this.mapCookies = new HashMap<>();
        }
        public void putCookie(String name, String value) {
            this.mapCookies.put(name, value);
        }
        public Cookie[] getCookies() {
            HttpServletRequest request = (HttpServletRequest) getRequest();
            Cookie[] cookies = request.getCookies();
            if (mapCookies == null || mapCookies.isEmpty()) {
                return cookies;
            }
            if (cookies == null || cookies.length == 0) {
                List<Cookie> cookieList = new LinkedList<>();
                for (Map.Entry<String, String> entry : mapCookies.entrySet()) {
                    String key = entry.getKey();
                    if (key != null && !"".equals(key)) {
                        cookieList.add(new Cookie(key, entry.getValue()));
                    }
                }
                if (cookieList.isEmpty()) {
                    return cookies;
                }
                return cookieList.toArray(new Cookie[cookieList.size()]);
            } else {
                List<Cookie> cookieList = new ArrayList<>(Arrays.asList(cookies));
                for (Map.Entry<String, String> entry : mapCookies.entrySet()) {
                    String key = entry.getKey();
                    if (key != null && !"".equals(key)) {
                        for (int i = 0; i < cookieList.size(); i++) {
                            if(cookieList.get(i).getName().equals(key)){
                                cookieList.remove(i);
                            }
                        }
                        cookieList.add(new Cookie(key, entry.getValue()));
                    }
                }
                return cookieList.toArray(new Cookie[cookieList.size()]);
            }
        }
    }
}
```

# 方案9: kubectl proxy

采用一种简单的办法，去掉token。就是在软件部署的节点利用kubeconfig文件，然后使用kubectl proxy代理，让访问Kubernetes API改成访问kubectl proxy

## 使用 kubectl 代理
下列命令使 kubectl 运行在反向代理模式下。它处理 API 服务器的定位和身份认证。

像这样运行它：

	kubectl proxy --port=8080 &

然后你可以通过 curl，wget，或浏览器浏览 API，像这样：

	curl http://localhost:8080/api/

输出类似如下：

```json
{
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "10.0.1.149:443"
    }
  ]
}
```

## 不使用 kubectl 代理
```bash
# 查看所有的集群，因为你的 .kubeconfig 文件中可能包含多个上下文
kubectl config view -o jsonpath='{"Cluster name\tServer\n"}{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'

# 从上述命令输出中选择你要与之交互的集群的名称
export CLUSTER_NAME="some_server_name"

# 指向引用该集群名称的 API 服务器
APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$CLUSTER_NAME\")].cluster.server}")

# 获得令牌
TOKEN=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 -d)

# 使用令牌玩转 API
curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
```

输出类似如下：

```json
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "10.0.1.149:443"
    }
  ]
}
```

# 问题1:  https认证问题
不通过代理转发直接调用Kubernetes API，https SSL认证没问题，代理转发后出现了https SSL认证问题。

可以采用命令行的curl命令加上`-k`参数避开，java代码中调用客户端库加入下面的内容
https://github.com/fabric8io/kubernetes-client/blob/master/kubernetes-examples/src/main/java/io/fabric8/kubernetes/examples/CredentialsExample.java
`configBuilder.withTrustCerts(true).build();`

kubectl可以通过加入参数`--insecure-skip-tls-verify`或替换kubeconfig文件的内容。

	kubectl --insecure-skip-tls-verify cluster-info dump

```yaml
clusters:
- cluster:
    certificate-authority-data: xxxxxx
```
中的`certificate-authority-data: xxxxxx`为` insecure-skip-tls-verify: true`

参考kubectl的解决办法，也可以用另一种方法修改java代码中调用客户端库，修改下面代码中的变量`String configYAML`
```java
    public static KubernetesClient fromYamlStringGetKubernetesClient(String configYAML) throws IOException {
        Config config = io.fabric8.kubernetes.client.Config.fromKubeconfig(configYAML);
        config.setTrustCerts(true);
        return new DefaultKubernetesClient(config);
    }
```

# 问题2: 调用Kuernetes API需要携带token，但是调用产品的接口想把token拿掉 
通过`方案9: kubectl proxy`解决

# 问题3: 拦截器修改header，添加token字段。失败。
通过`方案9: kubectl proxy`解决

# 问题4: 本地kubectl proxy有效，其他机器kubectl proxy无效。
将

	nohup kubectl proxy --port=8080 > /dev/null 2>&1 &
        
改成

	nohup kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$' --port=8080 > /dev/null 2>&1 &
	
后解决。

# 问题5: GET请求 redirect没有问题，但是POST请求redirect失败

GET请求 redirect没有问题，但是POST请求redirect失败，因为POST请求变成了GET请求
参考下面的几个文章：
* https://www.baeldung.com/spring-redirect-and-forward
* https://stackoverflow.com/questions/2068418/whats-the-difference-between-a-302-and-a-307-redirect
* https://blog.csdn.net/jerryJavaCoding/article/details/102961459

后问题解决。即：
在`return new RedirectView("http://<软件部署所在的ip>:33024/"+ newUrl);`前，加入`request.setAttribute(View.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);`后问题解决。

# 参考

## 方案6: nginx url映射

反向代理适用于很多场合，负载均衡是最普遍的用法。

nginx 作为目前最流行的web服务器之一，可以很方便地实现反向代理。

nginx 反向代理官方文档: NGINX REVERSE PROXY

当在一台主机上部署了多个不同的web服务器，并且需要能在80端口同时访问这些web服务器时，可以使用 nginx 的反向代理功能: 用 nginx 在80端口监听所有请求，并依据转发规则(比较常见的是以 URI 来转发)转发到对应的web服务器上。

例如有 webmail , webcom 以及 webdefault 三个服务器分别运行在 portmail , portcom , portdefault 端口，要实现从80端口同时访问这三个web服务器，则可以在80端口运行 nginx， 然后将 /mail 下的请求转发到 webmail 服务器， 将 /com下的请求转发到 webcom 服务器， 将其他所有请求转发到 webdefault 服务器。

假设服务器域名为example.com，则对应的 nginx http配置如下：

```java
http {
    server {
            server_name example.com;

            location /mail/ {
                    proxy_pass http://example.com:protmail/;
            }

            location /com/ {
                    proxy_pass http://example.com:portcom/main/;
            }

            location / {
                    proxy_pass http://example.com:portdefault;
            }
    }
}
```

以上的配置会按以下规则转发请求( GET 和 POST 请求都会转发):

将 http://example.com/mail/ 下的请求转发到 http://example.com:portmail/
将 http://example.com/com/ 下的请求转发到 http://example.com:portcom/main/
将其它所有请求转发到 http://example.com:portdefault/
需要注意的是，在以上的配置中，webdefault 的代理服务器设置是没有指定URI的，而 webmail 和 webcom 的代理服务器设置是指定了URI的(分别为 / 和 /main/)。
如果代理服务器地址中是带有URI的，此URI会替换掉 location 所匹配的URI部分。
而如果代理服务器地址中是不带有URI的，则会用完整的请求URL来转发到代理服务器。

官方文档描述：

If the URI is specified along with the address, it replaces the part of the request URI that matches the location parameter.
If the address is specified without a URI, or it is not possible to determine the part of URI to be replaced, the full request URI is passed (possibly, modified).

以上配置的转发示例：

	http://example.com/mail/index.html -> http://example.com:portmail/index.html
	http://example.com/com/index.html -> http://example.com:portcom/main/index.html
	http://example.com/mail/static/a.jpg -> http://example.com:portmail/static/a.jpg
	http://example.com/com/static/b.css -> http://example.com:portcom/main/static/b.css
	http://example.com/other/index.htm -> http://example.com:portdefault/other/index.htm





