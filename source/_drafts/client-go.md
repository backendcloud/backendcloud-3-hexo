---
title: client-go 静态和动态
date: 2022-04-26 22:57:01
categories: 云原生
tags:
- Golang
---
https://www.cnblogs.com/bolingcavalry/p/15245354.html

```go
type Config struct {
	Hosts []string
	Token string
}

func NewKubernetesClient(c *Config) (*kubernetes.Clientset, error) {
	var aliveHost string
	aliveHost, err := SelectAliveHost(c.Hosts)
	if err != nil {
		return nil, err
	}
	if !strings.Contains(aliveHost, ":") {
		aliveHost = fmt.Sprintf("%s:%d", aliveHost, constant.ClusterApiServerPort)
	}
	kubeConf := &rest.Config{
		Host:        string(aliveHost),
		BearerToken: c.Token,
		TLSClientConfig: rest.TLSClientConfig{
			Insecure: true,
		},
	}
	client, err := kubernetes.NewForConfig(kubeConf)
	if err != nil {
		return client, errors.Wrap(err, fmt.Sprintf("new kubernetes client with config failed: %v", err))
	}
	return client, nil
}

func NewKubernetesDynamicClient(c *Config) (dynamic.Interface, error) {
	var aliveHost string
	aliveHost, err := SelectAliveHost(c.Hosts)
	if err != nil {
		return nil, err
	}
	if !strings.Contains(aliveHost, ":") {
		aliveHost = fmt.Sprintf("%s:%d", aliveHost, constant.ClusterApiServerPort)
	}
	kubeConf := &rest.Config{
		Host:        string(aliveHost),
		BearerToken: c.Token,
		TLSClientConfig: rest.TLSClientConfig{
			Insecure: true,
		},
	}
	client, err := dynamic.NewForConfig(kubeConf)
	if err != nil {
		return client, errors.Wrap(err, fmt.Sprintf("new kubernetes client with config failed: %v", err))
	}
	return client, nil
}
```

```go
    config := kubeutil.Config{
		Hosts: service.hosts,
		Token: service.token,
	}
	clientset, err := kubeutil.NewKubernetesClient(&config)
	if err != nil {
		logger.Log.Errorf("get clientset error:%+v, host:%s", err, strings.Join(service.hosts, ","))
		return err
	}
	deploymentsClient := clientset.AppsV1().Deployments(apiv1.NamespaceDefault)
	list, _ := deploymentsClient.List(context.TODO(), metav1.ListOptions{})
	for _, d := range list.Items {
		fmt.Printf(" * deployment %s (%d replicas)\n", d.Name, *d.Spec.Replicas)
	}

	scClient := clientset.StorageV1().StorageClasses()
	scList, _ := scClient.List(context.TODO(), metav1.ListOptions{})
	for _, d := range scList.Items {
		fmt.Printf(" * sc %v %v\n", d.Name, d.Provisioner)
	}

	pvcClient := clientset.CoreV1().PersistentVolumeClaims(apiv1.NamespaceDefault)
	pvcList, _ := pvcClient.List(context.TODO(), metav1.ListOptions{})
	for _, d := range pvcList.Items {
		fmt.Printf(" * pvc %v %v\n", d.Name, d.Status.Capacity)
	}

	podClient := clientset.CoreV1().Pods(apiv1.NamespaceDefault)
	podList, _ := podClient.List(context.TODO(), metav1.ListOptions{})
	for _, d := range podList.Items {
		fmt.Printf(" * pod %v %v\n", d.Name, d.Status.PodIP)
	}
	
    var pod apiv1.Pod
	pod.APIVersion = "v1"
	pod.Kind = "Pod"
	pod.ObjectMeta = metav1.ObjectMeta{
		Name: "nginx-by-go",
	}
	containerList := make([]apiv1.Container, 0)
	containerList = append(containerList, apiv1.Container{
		Name:            "nginx-by-go",
		Image:           "registry.paas:8087/library/nginx",
		ImagePullPolicy: "IfNotPresent",
	})
	pod.Spec = apiv1.PodSpec{
		Containers: containerList,
	}
	podClient.Create(context.TODO(), &pod, metav1.CreateOptions{})
```

```go
    client, err := kubeutil.NewKubernetesDynamicClient(&config)
	podRes := schema.GroupVersionResource{Group: "", Version: "v1", Resource: "pods"}
	dynamicPod := &unstructured.Unstructured{
		Object: map[string]interface{}{
			"apiVersion": "v1",
			"kind":       "Pod",
			"metadata": map[string]interface{}{
				"name": "nginx",
			},
			"spec": map[string]interface{}{
				"containers": []map[string]interface{}{
					{
						"image":           "registry.paas:8087/library/nginx",
						"imagePullPolicy": "IfNotPresent",
						"name":            "nginx",
					},
				},
			},
		},
	}
	fmt.Println(dynamicPod)
	dynamicPodList, err := client.Resource(podRes).Namespace(apiv1.NamespaceDefault).List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		panic(err)
	}
	for _, d := range dynamicPodList.Items {
		fmt.Printf(" * dynamicPod %s \n", d.GetName())
	}
	createrResult, err := client.Resource(podRes).Namespace(apiv1.NamespaceDefault).Create(context.TODO(), dynamicPod, metav1.CreateOptions{})
	if err != nil {
		return err
	}
	fmt.Printf("Created deployment %q.\n", createrResult.GetName())
```

```go
    client, err := kubeutil.NewKubernetesDynamicClient(&config)
	gvr := schema.GroupVersionResource{Group: "", Version: "v1", Resource: "pods"}
	decoder := yaml.NewDecodingSerializer(unstructured.UnstructuredJSONScheme)
	obj := &unstructured.Unstructured{}
	var gvk schema.GroupVersionKind
	yamlData, err := ioutil.ReadFile("resources/simple.yaml")
	if _, _, err := decoder.Decode(yamlData, &gvk, obj); err != nil {
		return err
	}
	utd, err := client.Resource(gvr).Namespace(apiv1.NamespaceDefault).Create(context.TODO(), obj, metav1.CreateOptions{})
	if err != nil {
		return err
	}
	fmt.Println("utd")
	fmt.Println(utd)
```