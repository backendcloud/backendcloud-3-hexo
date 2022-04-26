---
title: client-go 静态和动态
date: 2022-04-26 22:57:01
categories: 云原生
tags:
- Golang
---

```go
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