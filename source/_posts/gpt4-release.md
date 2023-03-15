---
title: GPT4 各种专业和学术基准上表现出全面超越人类水平的表现
readmore: false
date: 2023-03-15 19:08:07
categories: 云原生
tags:
---

昨天OpenAI发布GPT4，相较于GPT3.5，GPT4的能力提升，官方给的回答是：在随意的谈话中，GPT-3.5 和 GPT-4 之间的区别可能很微妙。当任务的复杂性达到足够的阈值时，差异就会出现 GPT-4 比 GPT-3.5 更可靠、更有创意，并且能够处理更细微的指令。

另外GPT4是多模态，相对3，输入除了文本多了图像。（图像现在仍然是预览版的功能，还未开放）

官方举了个很形象的GPT4相较于3的推理能力和文字对话能力的一个例子。

![](/images/gpt4-release/2023-03-15-17-20-55.png)

上面是GPT3.5，老的GPT只能写到A-G，就编不下去了，新的GPT对这种任务非常轻松：

A beautiful Cinderella, dwelling eagerly, finally gains happiness; inspiring jealous kin, love magically nurtures opulent prince; quietly rescues, slipper triumphs, uniting very wondrously, xenial youth zealously.

**GPT4在最初为人类设计的模拟考试的测试结果**

![](/images/gpt4-release/2023-03-15-17-24-59.png)

从测试结果可以看出GPT4相较于3.5在统一律师资格考试，高考，GRE定量数学，提升显著，分别从和人类一起参加考试的排名后10%提升至前10%；后40%提升至前12%；后25%提升至前80%。

**GPT4在大规模多任务语言理解的测试结果**

GPT4之前的测试结果：

|                Model               | Authors |  Humanities |  Social Sciences  | STEM | Other | Average |
|------------------------------------|----------|:-------:|:-------:|:-------:|:-------:|:-------:|
| [Chinchilla](https://arxiv.org/abs/2203.15556) (70B, few-shot) | Hoffmann et al., 2022 | 63.6 | 79.3 | 54.9 | 73.9 | 67.5
| [Gopher](https://storage.googleapis.com/deepmind-media/research/language-research/Training%20Gopher.pdf) (280B, few-shot) | Rae et al., 2021 | 56.2 | 71.9 | 47.4 | 66.1 | 60.0
| [GPT-3](https://arxiv.org/abs/2005.14165) (175B, fine-tuned) | Brown et al., 2020 | 52.5 | 63.9 | 41.4 | 57.9 | 53.9
| [flan-T5-xl](https://arxiv.org/abs/2210.11416) | Chung et al., 2022 | 46.3 | 57.7 | 39.0 | 55.1 | 49.3
| [UnifiedQA](https://arxiv.org/abs/2005.00700) | Khashabi et al., 2020 | 45.6 | 56.6 | 40.2 | 54.6 | 48.9
| [GPT-3](https://arxiv.org/abs/2005.14165) (175B, few-shot) | Brown et al., 2020 | 40.8 | 50.4 | 36.7 | 48.8 | 43.9
| [GPT-3](https://arxiv.org/abs/2005.14165) (6.7B, fine-tuned) | Brown et al., 2020 | 42.1 | 49.2 | 35.1 | 46.9 | 43.2
| [flan-T5-large](https://arxiv.org/abs/2210.11416) | Chung et al., 2022 | 39.1 | 49.1 | 33.2 | 47.4 | 41.9
| [flan-T5-base](https://arxiv.org/abs/2210.11416) | Chung et al., 2022 | 34.0 | 38.1 | 27.6 | 37.0 | 34.2
| [GPT-2](https://arxiv.org/abs/2005.14165) | Radford et al., 2019 | 32.8 | 33.3 | 30.2 | 33.1 | 32.4
| [flan-T5-small](https://arxiv.org/abs/2210.11416) | Chung et al., 2022 | 29.9 | 30.9 | 27.5 | 29.7 | 29.5
| Random Baseline           | N/A | 25.0 | 25.0 | 25.0 | 25.0 | 25.0 | 25.0

GPT4的测试结果：

![](/images/gpt4-release/2023-03-15-17-25-33.png)

在为机器学习模型设计的传统基准上评估了 GPT-4。GPT-4 大大优于现有的大型语言模型，以及大多数最先进的 (SOTA) 模型。