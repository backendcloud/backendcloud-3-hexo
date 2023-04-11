---
title: 自动化 浪漫古风，AI添彩——ChatGPT 和 Dall-E 2 联手为中国古诗注入生命和色彩！
readmore: false
date: 2023-04-11 18:10:56
categories: Tools
tags:
- 中国古诗
- 一切皆可自动化
- ChatGPT
- AI绘图
---

本篇是自动化之前的一篇文章 {% post_link blog-cicd %} 

之前的文章整个过程分两部分，先和ChatGPT对话，获取ChatGPT对古诗文的理解，然后再调用Dall-E 2的接口，生成图像。这样的过程，需要人工的介入，不够自动化，所以我想到了一个新的方案，就是把ChatGPT和Dall-E 2整合到一起，生成图像，这样就不需要人工的介入了，完全自动化。

**先回顾下上篇文章的第一个示例：**

人类：
从现在开始，你是一名中英翻译，你会根据我输入的中文内容，翻译成对应英文。请注意，你翻译后的内容主要服务于一个绘画AI，它只能理解具象的描述而非抽象的概念，同时根据你对绘画AI的理解，比如它可能的训练模型、自然语言处理方式等方面，进行翻译优化。由于我的描述可能会很散乱，不连贯，你需要综合考虑这些问题，然后对翻译后的英文内容再次优化或重组，从而使绘画AI更能清楚我在说什么。请严格按照此条规则进行翻译，也只输出翻译后的英文内容。例如，我输入：一只想家的小狗。你不能输出：/imagine prompt: A homesick little dog. 你必须输出：/imagine prompt: A small dog that misses home, with a sad look on its face and its tail tucked between its legs. It might be standing in front of a closed door or a gate, gazing longingly into the distance, as if hoping to catch a glimpse of its beloved home. 如果你明白了，请回复"我准备好了"，当我输入中文内容后，请以"/imagine prompt:"作为开头，翻译我需要的英文内容。

ChatGPT：
我准备好了。

人类：
杨万里《晓出净慈寺送林子方》
毕竟西湖六月中，风光不与四时同。
接天莲叶无穷碧，映日荷花别样红。

ChatGPT：
/imagine prompt: In the middle of June, the scenery of West Lake is unique and not like any of the other four seasons. The endless green lotus leaves reach up to the sky, and the reflected sunlight makes the lotus flowers appear a vibrant shade of red. The natural beauty of the lake in the summertime is a sight to behold, and the speaker can't help but feel their spirit uplifted by the scene.

将ChatGPT生成的文本复制代码中，点击“运行”按钮，生成图像：

![](/images/poetry/2023-04-06-14-05-36.png)

**运行代码，调用Dall-E 2的接口，生成图像：**

![](/images/poetry/1.png)

**下面开始自动化该流程：**

本篇的代码放在： https://github.com/backendcloud/colab/blob/main/poem2picture.ipynb

**1. 安装openai的依赖包**

```python
TOKEN = "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"
! pip install openai
```

```bash
Looking in indexes: https://pypi.org/simple, https://us-python.pkg.dev/colab-wheels/public/simple/
Collecting openai
  Downloading openai-0.27.4-py3-none-any.whl (70 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 70.3/70.3 kB 2.4 MB/s eta 0:00:00
Requirement already satisfied: requests>=2.20 in /usr/local/lib/python3.9/dist-packages (from openai) (2.27.1)
Collecting aiohttp
  Downloading aiohttp-3.8.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.0/1.0 MB 17.2 MB/s eta 0:00:00
Requirement already satisfied: tqdm in /usr/local/lib/python3.9/dist-packages (from openai) (4.65.0)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (3.4)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (2022.12.7)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (1.26.15)
Requirement already satisfied: charset-normalizer~=2.0.0 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (2.0.12)
Collecting async-timeout<5.0,>=4.0.0a3
  Downloading async_timeout-4.0.2-py3-none-any.whl (5.8 kB)
Collecting frozenlist>=1.1.1
  Downloading frozenlist-1.3.3-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (158 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 158.8/158.8 kB 11.6 MB/s eta 0:00:00
Collecting yarl<2.0,>=1.0
  Downloading yarl-1.8.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (264 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 264.6/264.6 kB 16.4 MB/s eta 0:00:00
Requirement already satisfied: attrs>=17.3.0 in /usr/local/lib/python3.9/dist-packages (from aiohttp->openai) (22.2.0)
Collecting aiosignal>=1.1.2
  Downloading aiosignal-1.3.1-py3-none-any.whl (7.6 kB)
Collecting multidict<7.0,>=4.5
  Downloading multidict-6.0.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (114 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 114.2/114.2 kB 5.2 MB/s eta 0:00:00
Installing collected packages: multidict, frozenlist, async-timeout, yarl, aiosignal, aiohttp, openai
Successfully installed aiohttp-3.8.4 aiosignal-1.3.1 async-timeout-4.0.2 frozenlist-1.3.3 multidict-6.0.4 openai-0.27.4 yarl-1.8.2
```

**下面是完整代码：**

```python
import openai
openai.api_key = TOKEN

poem = '''
杨万里《晓出净慈寺送林子方》
毕竟西湖六月中，风光不与四时同。
接天莲叶无穷碧，映日荷花别样红。
'''

completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
        {"role": "system", "content": "从现在开始，你是一名中英翻译，你会根据我输入的中文内容，翻译成对应英文。请注意，你翻译后的内容主要服务于一个绘画AI，它只能理解具象的描述而非抽象的概念，同时根据你对绘画AI的理解，比如它可能的训练模型、自然语言处理方式等方面，进行翻译优化。由于我的描述可能会很散乱，不连贯，你需要综合考虑这些问题，然后对翻译后的英文内容再次优化或重组，从而使绘画AI更能清楚我在说什么。请严格按照此条规则进行翻译，也只输出翻译后的英文内容。例如，我输入：一只想家的小狗。你不能输出：/imagine prompt: A homesick little dog. 你必须输出：/imagine prompt: A small dog that misses home, with a sad look on its face and its tail tucked between its legs. It might be standing in front of a closed door or a gate, gazing longingly into the distance, as if hoping to catch a glimpse of its beloved home. 当我输入中文内容后，请以”/imagine prompt:”作为开头，翻译我需要的英文内容。"},
        {"role": "user", "content": poem},
    ]
)
print(completion.choices[0].message.content)

PROMPT = completion.choices[0].message.content
response = openai.Image.create(
    prompt=PROMPT,
    n=1,
    size="512x512",
)

print(response["data"][0]["url"])
```

**程序运行结果：**

```bash
/imagine prompt: A scene depicting the beauty of mid-June in West Lake as described in the poem "Seeing Lin Zifang Off to Jingci Temple in the Morning" by Yang Wanli. The view is different from other times of the year. In the painting, endless green lotus leaves reach up towards the sky, while the reflection of the sun on the water makes the lotus flowers appear a unique shade of red.

https://oaidalleapiprodscus.blob.core.windows.net/private/org-zuDRR3x1ffIDMMVwGrkclQZ4/user-5TI7TlKvDEP8J1l1ByNdpdRp/img-jgOhwyqQw7UZEbxo9CWhLK2a.png?st=2023-04-11T07%3A27%3A54Z&se=2023-04-11T09%3A27%3A54Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-04-10T23%3A44%3A51Z&ske=2023-04-11T23%3A44%3A51Z&sks=b&skv=2021-08-06&sig=yC%2BJvbd6fC3jeaMwtaucQ1WiV4opebbE4iTPNR2wV7k%3D
```

> 上面的URL就是生成的图片，可以直接在浏览器中打开。

**调用Dall-E 2的接口，生成图像的费用有点小贵，费用如下：**

Resolution  | Price
--- | ---
1024×1024|  $0.020 / image
512×512| $0.018 / image
256×256| $0.016 / image