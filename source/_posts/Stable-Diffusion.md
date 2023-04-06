---
title: 用Stable Diffusion画美女
readmore: false
date: 2023-04-04 08:13:18
categories: Tools
tags:
- AI
---

Stable Diffusion是一个基于Latent Diffusion Models（潜在扩散模型，LDMs）的文图生成（text-to-image）模型。它是由CompVis、Stability AI和LAION共同开发的一个文本转图像模型，可以将文本描述转换为图像。

**安装 Stable Diffusion 和 模板库**

这里选了一套比较像真人的模板库

```bash
Installing gfpgan
Installing clip
Installing open_clip
Cloning Stable Diffusion into /content/stable-diffusion-webui/repositories/stable-diffusion-stability-ai...
Cloning Taming Transformers into /content/stable-diffusion-webui/repositories/taming-transformers...
Cloning K-diffusion into /content/stable-diffusion-webui/repositories/k-diffusion...
Cloning CodeFormer into /content/stable-diffusion-webui/repositories/CodeFormer...
Cloning BLIP into /content/stable-diffusion-webui/repositories/BLIP...
Installing requirements for CodeFormer
Installing requirements for Web UI
Installing sd-webui-controlnet requirement: svglib


Installing Deforum requirement: av
Installing Deforum requirement: pims


Installing rembg
Installing onnxruntime for REMBG extension
Installing pymatting for REMBG extension

Installing pycloudflared


Launching Web UI with arguments: --listen --xformers --enable-insecure-extension-access --theme dark --gradio-queue --multiple
2023-04-06 02:26:14.767376: I tensorflow/core/platform/cpu_feature_guard.cc:182] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
To enable the following instructions: AVX2 AVX512F FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.
2023-04-06 02:26:16.773685: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:38] TF-TRT Warning: Could not find TensorRT
Additional Network extension not installed, Only hijack built-in lora
LoCon Extension hijack built-in lora successfully
[AddNet] Updating model hashes...
0it [00:00, ?it/s]
[AddNet] Updating model hashes...
0it [00:00, ?it/s]
all detected, remote.moe trying to connect...
Warning: Permanently added 'localhost.run,54.82.85.249' (RSA) to the list of known hosts.
Warning: Permanently added 'remote.moe,159.69.126.209' (ECDSA) to the list of known hosts.
all detected, cloudflared trying to connect...
Download cloudflared...: 100% 34.0M/34.0M [00:00<00:00, 445MB/s]
Calculating sha256 for /content/stable-diffusion-webui/models/Stable-diffusion/chilloutmix_NiPrunedFp32Fix.safetensors: fc2511737a54c5e80b89ab03e0ab4b98d051ab187f92860f3cd664dc9d08b271
Loading weights [fc2511737a] from /content/stable-diffusion-webui/models/Stable-diffusion/chilloutmix_NiPrunedFp32Fix.safetensors
Creating model from config: /content/stable-diffusion-webui/configs/v1-inference.yaml
LatentDiffusion: Running in eps-prediction mode
DiffusionWrapper has 859.52 M params.
Downloading (…)olve/main/vocab.json: 961kB [00:00, 1.49MB/s]
Downloading (…)olve/main/merges.txt: 525kB [00:00, 1.21MB/s]
Downloading (…)cial_tokens_map.json: 100% 389/389 [00:00<00:00, 41.9kB/s]
Downloading (…)okenizer_config.json: 100% 905/905 [00:00<00:00, 285kB/s]
Downloading (…)lve/main/config.json: 4.52kB [00:00, 3.55MB/s]
Applying xformers cross attention optimization.
Textual inversion embeddings loaded(7): bad_prompt_version2, bad-artist, bad-artist-anime, ng_deepnegative_v1_75t, bad-image-v2-39000, EasyNegative, bad-hands-5
Model loaded in 54.0s (calculate hash: 23.7s, load weights from disk: 0.6s, create model: 14.8s, apply weights to model: 14.7s).
*Deforum ControlNet support: enabled*
```

![](/images/Stable-Diffusion/2023-04-05-08-06-09.png)

![](/images/Stable-Diffusion/2023-04-05-08-06-39.png)

**安装好后，进入界面：**

![](/images/Stable-Diffusion/2023-04-05-08-06-52.png)

**提示词：**

(8k, RAW photo, best quality, masterpiece:1.2), (realistic, photo-realistic:1.4), ultra-detailed, (Kpop idol),perfect detail ,  looking at viewer,make up,


paintings,sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, skin blemishes, bad anatomy,(long hair:1.4),DeepNegative,(fat:1.2),facing away, looking away,tilted head, {Multiple people}, lowres,bad anatomy,bad hands, text, error, missing fingers,extra digit, fewer digits, cropped, worstquality, low quality, normal quality,jpegartifacts,signature, watermark, username,blurry,bad feet,cropped,poorly drawn hands,poorly drawn face,mutation,deformed,worst quality,low quality,normal quality,jpeg artifacts,signature,watermark,extra fingers,fewer digits,extra limbs,extra arms,extra legs,malformed limbs,fused fingers,too many fingers,long neck,cross-eyed,mutated hands,polar lowres,bad body,bad proportions,gross proportions,text,error,missing fingers,missing arms,missing legs,extra digit, extra arms, extra leg, extra foot,

![](/images/Stable-Diffusion/2023-04-05-08-09-11.png)

![](/images/Stable-Diffusion/2023-04-05-08-09-44.png)

![](/images/Stable-Diffusion/2023-04-05-08-10-55.png)

**下面是 用Stable Diffusion AI生成的几张照片：**

![](/images/Stable-Diffusion/1.png)

![](/images/Stable-Diffusion/2.png)

![](/images/Stable-Diffusion/3.png)

![](/images/Stable-Diffusion/4.png)

感觉是一个模子，把人物的特征填充进去，然后就可以生成各种各样的人物了。有点像真人，但离真人还是有一定差距的，但是这个技术还是很有意思的。

算了，还是直接看真人吧！