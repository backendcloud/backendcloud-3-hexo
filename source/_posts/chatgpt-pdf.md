---
title: 用ChatGPT技术来分析和翻译PDF文档，开启新时代的PDF文档处理方式
readmore: false
date: 2023-04-03 11:56:55
categories: Tools
tags:
- ChatGPT
- PDF
---

> 本篇的源码放在 https://github.com/backendcloud/colab/blob/main/gpt-pdf.ipynb

在当今科技快速发展的时代，PDF文件已经成为许多人工作生活中不可或缺的一部分。然而，对PDF文档进行分析和翻译仍然是一个相当繁琐的过程。但现在，随着ChatGPT技术的出现，这个过程变得更加高效和准确了。

ChatGPT是一项先进的人工智能技术，可以通过深度学习和自然语言处理来理解和解析PDF文档。使用ChatGPT进行PDF分析和翻译的主要好处之一是高速和精准度。与传统的OCR方法相比，ChatGPT不仅可以识别文本，还可以识别和理解图像和表格内容，并输出高质量的分析结果。

而且，ChatGPT还可以进行翻译，将PDF文档从一种语言翻译到另一种语言。这项功能对于那些需要处理多种语言的项目或文档的人来说非常有用，也可以帮助跨国公司更轻松地处理不同国别的客户或业务伙伴。

总之，ChatGPT的出现带来了PDF分析和翻译方面的变革，并且将继续推动这个领域的发展。

用ChatGPT分析PDF，已经有一些商业产品推出了。今天来测试下，首先随机找了一篇最新发表的论文，用ChatGPT来辅助分析一下论文。

![](/images/chatgpt-pdf/2023-04-03-10-09-29.png)

![](/images/chatgpt-pdf/2023-04-03-10-11-18.png)

![](/images/chatgpt-pdf/2023-04-03-10-16-17.png)

看了下结果，分析的也是简单的文字整合，显然没有真正读懂论文，也没有给出详细的分析。问了点难点的具体细节，直接卡壳了。

这类利用ChatGPT的商用网站，说白了还是调用的GPT API，输出结果还都是GPT给出的回答。商用网站做的工作是设计一些交互和辅助一些提示词。

下面分析下实现的源码，以翻译PDF为例，看看是怎么实现的。（分析PDF类似，只是提示词从翻译改成分析，解释等）

## 互联网上找一个pdf文件，这里就用了openai官网的gpt-4的文档作为示例。用requests库，将pdf文件下载下来。

```python
import requests
res = requests.get('https://cdn.openai.com/papers/gpt-4.pdf')
with open('gpt-4.pdf', 'wb') as f:
  f.write(res.content)
```
     
## 使用pypdf库获取pdf文件里的文字内容

```bash
! pip install pypdf
     
Looking in indexes: https://pypi.org/simple, https://us-python.pkg.dev/colab-wheels/public/simple/
Collecting pypdf
  Downloading pypdf-3.7.0-py3-none-any.whl (246 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 246.9/246.9 KB 10.7 MB/s eta 0:00:00
Requirement already satisfied: typing_extensions>=3.10.0.0 in /usr/local/lib/python3.9/dist-packages (from pypdf) (4.5.0)
Installing collected packages: pypdf
Successfully installed pypdf-3.7.0
```

```python
from pypdf import PdfReader

reader = PdfReader("gpt-4.pdf")
number_of_pages = len(reader.pages)
page = reader.pages[0]
text = page.extract_text()
text
```

'GPT-4 Technical Report\nOpenAI\x03\nAbstract\nWe report the development of GPT-4, a large-scale, multimodal model which can\naccept image and text inputs and produce text outputs. While less capable than\nhumans in many real-world scenarios, GPT-4 exhibits human-level performance\non various professional and academic benchmarks, including passing a simulated\nbar exam with a score around the top 10% of test takers. GPT-4 is a Transformer-\nbased model pre-trained to predict the next token in a document. The post-training\nalignment process results in improved performance on measures of factuality and\nadherence to desired behavior. A core component of this project was developing\ninfrastructure and optimization methods that behave predictably across a wide\nrange of scales. This allowed us to accurately predict some aspects of GPT-4’s\nperformance based on models trained with no more than 1/1,000th the compute of\nGPT-4.\n1 Introduction\nThis technical report presents GPT-4, a large multimodal model capable of processing image and\ntext inputs and producing text outputs. Such models are an important area of study as they have the\npotential to be used in a wide range of applications, such as dialogue systems, text summarization,\nand machine translation. As such, they have been the subject of substantial interest and progress in\nrecent years [1–34].\nOne of the main goals of developing such models is to improve their ability to understand and generate\nnatural language text, particularly in more complex and nuanced scenarios. To test its capabilities\nin such scenarios, GPT-4 was evaluated on a variety of exams originally designed for humans. In\nthese evaluations it performs quite well and often outscores the vast majority of human test takers.\nFor example, on a simulated bar exam, GPT-4 achieves a score that falls in the top 10% of test takers.\nThis contrasts with GPT-3.5, which scores in the bottom 10%.\nOn a suite of traditional NLP benchmarks, GPT-4 outperforms both previous large language models\nand most state-of-the-art systems (which often have benchmark-speciﬁc training or hand-engineering).\nOn the MMLU benchmark [ 35,36], an English-language suite of multiple-choice questions covering\n57 subjects, GPT-4 not only outperforms existing models by a considerable margin in English, but\nalso demonstrates strong performance in other languages. On translated variants of MMLU, GPT-4\nsurpasses the English-language state-of-the-art in 24 of 26 languages considered. We discuss these\nmodel capability results, as well as model safety improvements and results, in more detail in later\nsections.\nThis report also discusses a key challenge of the project, developing deep learning infrastructure and\noptimization methods that behave predictably across a wide range of scales. This allowed us to make\npredictions about the expected performance of GPT-4 (based on small runs trained in similar ways)\nthat were tested against the ﬁnal run to increase conﬁdence in our training.\nDespite its capabilities, GPT-4 has similar limitations to earlier GPT models [ 1,37,38]: it is not fully\nreliable (e.g. can suffer from “hallucinations”), has a limited context window, and does not learn\n\x03Please cite this work as “OpenAI (2023)". Full authorship contribution statements appear at the end of the\ndocument. Correspondence regarding this technical report can be sent to gpt4-report@openai.comarXiv:submit/4812508  [cs.CL]  27 Mar 2023'

## 本来这里就可以调用GPT API进行处理了，但是GPT有单词输入文字的最大限制。所以要对pdf里的文字切分。等比例切分会中断句子。这里用了自然语言处理NLTK库，按句子的意思进行切分。

```bash
! pip install nltk
     
Looking in indexes: https://pypi.org/simple, https://us-python.pkg.dev/colab-wheels/public/simple/
Requirement already satisfied: nltk in /usr/local/lib/python3.9/dist-packages (3.8.1)
Requirement already satisfied: tqdm in /usr/local/lib/python3.9/dist-packages (from nltk) (4.65.0)
Requirement already satisfied: click in /usr/local/lib/python3.9/dist-packages (from nltk) (8.1.3)
Requirement already satisfied: regex>=2021.8.3 in /usr/local/lib/python3.9/dist-packages (from nltk) (2022.10.31)
Requirement already satisfied: joblib in /usr/local/lib/python3.9/dist-packages (from nltk) (1.1.1)

from nltk.tokenize import sent_tokenize
import nltk
nltk.download('punkt')

     
[nltk_data] Downloading package punkt to /root/nltk_data...
[nltk_data]   Unzipping tokenizers/punkt.zip.
True
```

```python
sentences = sent_tokenize(text)
     

for sentence in sentences:
    print(sentence)
    print('=' * 20)
```

GPT-4 Technical Report
OpenAI
Abstract
We report the development of GPT-4, a large-scale, multimodal model which can
accept image and text inputs and produce text outputs.
====================
While less capable than
humans in many real-world scenarios, GPT-4 exhibits human-level performance
on various professional and academic benchmarks, including passing a simulated
bar exam with a score around the top 10% of test takers.
====================
GPT-4 is a Transformer-
based model pre-trained to predict the next token in a document.
====================
The post-training
alignment process results in improved performance on measures of factuality and
adherence to desired behavior.
====================
A core component of this project was developing
infrastructure and optimization methods that behave predictably across a wide
range of scales.
====================
This allowed us to accurately predict some aspects of GPT-4’s
performance based on models trained with no more than 1/1,000th the compute of
GPT-4.
====================
1 Introduction
This technical report presents GPT-4, a large multimodal model capable of processing image and
text inputs and producing text outputs.
====================
Such models are an important area of study as they have the
potential to be used in a wide range of applications, such as dialogue systems, text summarization,
and machine translation.
====================
As such, they have been the subject of substantial interest and progress in
recent years [1–34].
====================
One of the main goals of developing such models is to improve their ability to understand and generate
natural language text, particularly in more complex and nuanced scenarios.
====================
To test its capabilities
in such scenarios, GPT-4 was evaluated on a variety of exams originally designed for humans.
====================
In
these evaluations it performs quite well and often outscores the vast majority of human test takers.
====================
For example, on a simulated bar exam, GPT-4 achieves a score that falls in the top 10% of test takers.
====================
This contrasts with GPT-3.5, which scores in the bottom 10%.
====================
On a suite of traditional NLP benchmarks, GPT-4 outperforms both previous large language models
and most state-of-the-art systems (which often have benchmark-speciﬁc training or hand-engineering).
====================
On the MMLU benchmark [ 35,36], an English-language suite of multiple-choice questions covering
57 subjects, GPT-4 not only outperforms existing models by a considerable margin in English, but
also demonstrates strong performance in other languages.
====================
On translated variants of MMLU, GPT-4
surpasses the English-language state-of-the-art in 24 of 26 languages considered.
====================
We discuss these
model capability results, as well as model safety improvements and results, in more detail in later
sections.
====================
This report also discusses a key challenge of the project, developing deep learning infrastructure and
optimization methods that behave predictably across a wide range of scales.
====================
This allowed us to make
predictions about the expected performance of GPT-4 (based on small runs trained in similar ways)
that were tested against the ﬁnal run to increase conﬁdence in our training.
====================
Despite its capabilities, GPT-4 has similar limitations to earlier GPT models [ 1,37,38]: it is not fully
reliable (e.g.
====================
can suffer from “hallucinations”), has a limited context window, and does not learn
Please cite this work as “OpenAI (2023)".
====================
Full authorship contribution statements appear at the end of the
document.
====================
Correspondence regarding this technical report can be sent to gpt4-report@openai.comarXiv:submit/4812508  [cs.CL]  27 Mar 2023
====================

## 调用GPT API对分段的文字进行翻译

```bash
! pip install openai
     
Looking in indexes: https://pypi.org/simple, https://us-python.pkg.dev/colab-wheels/public/simple/
Collecting openai
  Downloading openai-0.27.2-py3-none-any.whl (70 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 70.1/70.1 KB 4.5 MB/s eta 0:00:00
Collecting aiohttp
  Downloading aiohttp-3.8.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.0/1.0 MB 30.5 MB/s eta 0:00:00
Requirement already satisfied: tqdm in /usr/local/lib/python3.9/dist-packages (from openai) (4.65.0)
Requirement already satisfied: requests>=2.20 in /usr/local/lib/python3.9/dist-packages (from openai) (2.27.1)
Requirement already satisfied: charset-normalizer~=2.0.0 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (2.0.12)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (2022.12.7)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (1.26.15)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/dist-packages (from requests>=2.20->openai) (3.4)
Collecting async-timeout<5.0,>=4.0.0a3
  Downloading async_timeout-4.0.2-py3-none-any.whl (5.8 kB)
Collecting multidict<7.0,>=4.5
  Downloading multidict-6.0.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (114 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 114.2/114.2 KB 15.7 MB/s eta 0:00:00
Collecting yarl<2.0,>=1.0
  Downloading yarl-1.8.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (264 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 264.6/264.6 KB 29.6 MB/s eta 0:00:00
Collecting aiosignal>=1.1.2
  Downloading aiosignal-1.3.1-py3-none-any.whl (7.6 kB)
Requirement already satisfied: attrs>=17.3.0 in /usr/local/lib/python3.9/dist-packages (from aiohttp->openai) (22.2.0)
Collecting frozenlist>=1.1.1
  Downloading frozenlist-1.3.3-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (158 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 158.8/158.8 KB 21.1 MB/s eta 0:00:00
Installing collected packages: multidict, frozenlist, async-timeout, yarl, aiosignal, aiohttp, openai
Successfully installed aiohttp-3.8.4 aiosignal-1.3.1 async-timeout-4.0.2 frozenlist-1.3.3 multidict-6.0.4 openai-0.27.2 yarl-1.8.2
```

```python
import openai
openai.api_key = TOKEN

completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
        {"role": "system", "content": "请你成为文章翻译的小帮手，请协助翻译以下技术文件，以简体中文输出"},
        {"role": "user", "content": sentences[0]},
    ]
)
completion.choices[0].message.content
```

'GPT-4技术报告\nOpenAI\n摘要\n本文报告了GPT-4的开发情况，这是一个大规模的、多模态模型，能够接受图像和文本输入，并生成文本输出。'

```python
input_sentences = ''
chunks = []
for sentence in sentences:
  input_sentences += sentence
  if len(input_sentences) > 1000:
    chunks.append(input_sentences)
    input_sentences = ''
chunks.append(input_sentences)
chunks
```

['GPT-4 Technical Report\nOpenAI\x03\nAbstract\nWe report the development of GPT-4, a large-scale, multimodal model which can\naccept image and text inputs and produce text outputs.While less capable than\nhumans in many real-world scenarios, GPT-4 exhibits human-level performance\non various professional and academic benchmarks, including passing a simulated\nbar exam with a score around the top 10% of test takers.GPT-4 is a Transformer-\nbased model pre-trained to predict the next token in a document.The post-training\nalignment process results in improved performance on measures of factuality and\nadherence to desired behavior.A core component of this project was developing\ninfrastructure and optimization methods that behave predictably across a wide\nrange of scales.This allowed us to accurately predict some aspects of GPT-4’s\nperformance based on models trained with no more than 1/1,000th the compute of\nGPT-4.1 Introduction\nThis technical report presents GPT-4, a large multimodal model capable of processing image and\ntext inputs and producing text outputs.',
 'Such models are an important area of study as they have the\npotential to be used in a wide range of applications, such as dialogue systems, text summarization,\nand machine translation.As such, they have been the subject of substantial interest and progress in\nrecent years [1–34].One of the main goals of developing such models is to improve their ability to understand and generate\nnatural language text, particularly in more complex and nuanced scenarios.To test its capabilities\nin such scenarios, GPT-4 was evaluated on a variety of exams originally designed for humans.In\nthese evaluations it performs quite well and often outscores the vast majority of human test takers.For example, on a simulated bar exam, GPT-4 achieves a score that falls in the top 10% of test takers.This contrasts with GPT-3.5, which scores in the bottom 10%.On a suite of traditional NLP benchmarks, GPT-4 outperforms both previous large language models\nand most state-of-the-art systems (which often have benchmark-speciﬁc training or hand-engineering).',
 'On the MMLU benchmark [ 35,36], an English-language suite of multiple-choice questions covering\n57 subjects, GPT-4 not only outperforms existing models by a considerable margin in English, but\nalso demonstrates strong performance in other languages.On translated variants of MMLU, GPT-4\nsurpasses the English-language state-of-the-art in 24 of 26 languages considered.We discuss these\nmodel capability results, as well as model safety improvements and results, in more detail in later\nsections.This report also discusses a key challenge of the project, developing deep learning infrastructure and\noptimization methods that behave predictably across a wide range of scales.This allowed us to make\npredictions about the expected performance of GPT-4 (based on small runs trained in similar ways)\nthat were tested against the ﬁnal run to increase conﬁdence in our training.Despite its capabilities, GPT-4 has similar limitations to earlier GPT models [ 1,37,38]: it is not fully\nreliable (e.g.can suffer from “hallucinations”), has a limited context window, and does not learn\n\x03Please cite this work as “OpenAI (2023)".',
 'Full authorship contribution statements appear at the end of the\ndocument.Correspondence regarding this technical report can be sent to gpt4-report@openai.comarXiv:submit/4812508  [cs.CL]  27 Mar 2023']

```python
completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
        {"role": "system", "content": "请你成为文章翻译的小帮手，请协助翻译以下技术文件，以简体中文输出"},
        {"role": "user", "content": chunks[0]},
    ]
)
completion.choices[0].message.content
```

'GPT-4技术报告\nOpenAI\n摘要\n本文报道了GPT-4的开发情况，它是一个可接收图像和文本输入并生成文本输出的大规模多模态模型。虽然在许多实际情境中比人类能力差，但在各种专业和学术基准测试中，GPT-4表现出人类水平的性能，包括在模拟的律师考试中获得了约是前10%考生的成绩。GPT-4是基于Transformer的模型，预先训练以预测文档中的下一个标记。后训练对齐过程提高了其实际性能和符合所需行为的程度。该项目的核心组件是开发基础设施和优化方法，可在各种规模上可靠地预测GPT-4的某些方面性能，其中包括了通过使用不超过GPT-4计算量的1/1000的模型进行训练。\n1介绍\n本技术报告介绍了GPT-4，它是一个大规模多模态模型，能够处理图像和文本输入并生成文本输出。'

## 下面的代码将上面的所有分片的代码拼在在一起，完成对完整的pdf的翻译。

```python
from pypdf import PdfReader
from nltk.tokenize import sent_tokenize

pdf_name = "gpt-4.pdf" 
reader = PdfReader(pdf_name)
number_of_pages = len(reader.pages)

chunks = []

for i in range(number_of_pages):
  page = reader.pages[i]
  text = page.extract_text()
  sentences = sent_tokenize(text)
  input_sentences = ''
  
  for sentence in sentences:
    input_sentences += sentence
    if len(input_sentences) > 1000:
      chunks.append(input_sentences)
      input_sentences = ''
  chunks.append(input_sentences)

for i in range(10):
  completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
        {"role": "system", "content": "请你成为文章翻译的小帮手，请协助翻译以下技术文件，以简体中文输出"},
        {"role": "user", "content": chunks[i]},
    ]
  )
  print('原文:', chunks[i])
  print('翻译结果:',completion.choices[0].message.content)
```

原文: GPT-4 Technical Report
OpenAI
Abstract
We report the development of GPT-4, a large-scale, multimodal model which can
accept image and text inputs and produce text outputs.While less capable than
humans in many real-world scenarios, GPT-4 exhibits human-level performance
on various professional and academic benchmarks, including passing a simulated
bar exam with a score around the top 10% of test takers.GPT-4 is a Transformer-
based model pre-trained to predict the next token in a document.The post-training
alignment process results in improved performance on measures of factuality and
adherence to desired behavior.A core component of this project was developing
infrastructure and optimization methods that behave predictably across a wide
range of scales.This allowed us to accurately predict some aspects of GPT-4’s
performance based on models trained with no more than 1/1,000th the compute of
GPT-4.1 Introduction
This technical report presents GPT-4, a large multimodal model capable of processing image and
text inputs and producing text outputs.
翻译结果: GPT-4技术报告
OpenAI

摘要
本文报告了GPT-4的开发情况，这是一个大规模、多模态模型，可以接收图像和文本输入并产生文本输出。尽管在许多真实世界场景中不如人类能力强，但GPT-4在各种专业和学术基准测试中表现出人类水平的性能，包括通过模拟的律师考试，成绩位列前10%的考生之列。GPT-4是一个基于Transformer的预训练模型，用于预测文档中的下一个标记。后训练对齐过程改善了事实和符合预期行为的表现。这个项目的核心组件是开发基础设施和优化方法，能够可靠地适应各种规模。这使得我们能够基于使用了不到GPT-4计算功率1/1000的训练模型来准确预测GPT-4的某些性能方面。
1 简介
本技术报告介绍GPT-4，这是一个大型多模态模型，能够处理图像和文本输入并产生文本输出。
原文: Such models are an important area of study as they have the
potential to be used in a wide range of applications, such as dialogue systems, text summarization,
and machine translation.As such, they have been the subject of substantial interest and progress in
recent years [1–34].One of the main goals of developing such models is to improve their ability to understand and generate
natural language text, particularly in more complex and nuanced scenarios.To test its capabilities
in such scenarios, GPT-4 was evaluated on a variety of exams originally designed for humans.In
these evaluations it performs quite well and often outscores the vast majority of human test takers.For example, on a simulated bar exam, GPT-4 achieves a score that falls in the top 10% of test takers.This contrasts with GPT-3.5, which scores in the bottom 10%.On a suite of traditional NLP benchmarks, GPT-4 outperforms both previous large language models
and most state-of-the-art systems (which often have benchmark-speciﬁc training or hand-engineering).
翻译结果: 这些模型是研究的重要领域，因为它们具有广泛应用的潜力，例如对话系统、文本摘要和机器翻译。因此，它们在近年来受到了广泛的关注和进展[1-34]。开发这样的模型的主要目的之一是提高它们理解和生成自然语言文本的能力，特别是在更复杂和微妙的情况下。为了测试它在这些情况下的能力，GPT-4在一系列最初为人类设计的考试中进行了评估。在这些评估中，它表现出色，常常超过绝大多数人类考试者。例如，在模拟的律师考试中，GPT-4获得了处于前10％考试者的成绩。这与GPT-3.5形成对比，后者的成绩处于最低10％。在一套传统的自然语言处理基准测试中，GPT-4的表现优于之前的大型语言模型和大多数最先进的系统（这些系统通常具有基准测试特定的训练或手工工程）。
原文: On the MMLU benchmark [ 35,36], an English-language suite of multiple-choice questions covering
57 subjects, GPT-4 not only outperforms existing models by a considerable margin in English, but
also demonstrates strong performance in other languages.On translated variants of MMLU, GPT-4
surpasses the English-language state-of-the-art in 24 of 26 languages considered.We discuss these
model capability results, as well as model safety improvements and results, in more detail in later
sections.This report also discusses a key challenge of the project, developing deep learning infrastructure and
optimization methods that behave predictably across a wide range of scales.This allowed us to make
predictions about the expected performance of GPT-4 (based on small runs trained in similar ways)
that were tested against the ﬁnal run to increase conﬁdence in our training.Despite its capabilities, GPT-4 has similar limitations to earlier GPT models [ 1,37,38]: it is not fully
reliable (e.g.can suffer from “hallucinations”), has a limited context window, and does not learn
Please cite this work as “OpenAI (2023)".
翻译结果: 在MMLU基准测试[35,36]中，这是一个包含57个主题的英语选择题套件，GPT-4不仅在英语方面的表现远远超过现有的模型，而且还展现出其他语言的强大性能。在翻译版本的MMLU上，GPT-4在考虑的26种语言中的24种语言中超越了英语状态下的最新成果。我们在后面的部分中详细讨论了这些模型能力的结果，以及模型安全性的改进和结果。本报告还讨论了该项目的一个关键挑战，即开发能够在各种规模下可预测行为的深度学习基础设施和优化方法。这使我们能够对GPT-4的预期表现进行预测（基于以类似方式训练的小型运行），并将其与最终运行进行测试，以增加我们的训练信心。尽管GPT-4具有类似于早期GPT模型[1,37,38]的功能，但它并不完全可靠（例如可能会出现“幻觉”），具有有限的上下文窗口，并且无法学习其他任务。请将本文注引用为“OpenAI（2023）”。
原文: Full authorship contribution statements appear at the end of the
document.Correspondence regarding this technical report can be sent to gpt4-report@openai.comarXiv:submit/4812508  [cs.CL]  27 Mar 2023
翻译结果: 所有作者的完整贡献声明将出现在文档末尾。有关本技术报告的通信可发送至gpt4-report@openai.com。arXiv:submit/4812508 [cs.CL]，2023年3月27日。
原文: from experience.Care should be taken when using the outputs of GPT-4, particularly in contexts
where reliability is important.GPT-4’s capabilities and limitations create signiﬁcant and novel safety challenges, and we believe
careful study of these challenges is an important area of research given the potential societal impact.This report includes an extensive system card (after the Appendix) describing some of the risks we
foresee around bias, disinformation, over-reliance, privacy, cybersecurity, proliferation, and more.It also describes interventions we made to mitigate potential harms from the deployment of GPT-4,
including adversarial testing with domain experts, and a model-assisted safety pipeline.2 Scope and Limitations of this Technical Report
This report focuses on the capabilities, limitations, and safety properties of GPT-4.GPT-4 is a
Transformer-style model [ 39] pre-trained to predict the next token in a document, using both publicly
available data (such as internet data) and data licensed from third-party providers.
翻译结果: 来自经验的观察表明，使用GPT-4的输出时应谨慎，特别是在可靠性很重要的情况下。GPT-4的能力和限制带来了重大且新颖的安全挑战，我们认为认真研究这些挑战是一个重要的研究领域，因为会对社会造成潜在的影响。本报告包括一个系统说明书（在附录之后），描述我们预见的关于偏见、虚假信息、过度依赖、隐私、网络安全、扩散等风险，并描述了我们为减少GPT-4部署可能造成的潜在危害所做的干预措施，包括与领域专家进行对抗测试和模型辅助安全流程。本技术报告的范围和限制为：重点关注GPT-4的能力、限制和安全性质。GPT-4是一种Transformer风格的模型[39]，预先训练以预测文档中的下一个标记，使用了公开可用的数据（如互联网数据）和从第三方提供商获得的数据。
原文: The model was
then ﬁne-tuned using Reinforcement Learning from Human Feedback (RLHF) [ 40].Given both
the competitive landscape and the safety implications of large-scale models like GPT-4, this report
contains no further details about the architecture (including model size), hardware, training compute,
dataset construction, training method, or similar.We are committed to independent auditing of our technologies, and shared some initial steps and
ideas in this area in the system card accompanying this release.2We plan to make further technical
details available to additional third parties who can advise us on how to weigh the competitive and
safety considerations above against the scientiﬁc value of further transparency.3 Predictable Scaling
A large focus of the GPT-4 project was building a deep learning stack that scales predictably.The
primary reason is that for very large training runs like GPT-4, it is not feasible to do extensive
model-speciﬁc tuning.To address this, we developed infrastructure and optimization methods that
have very predictable behavior across multiple scales.
翻译结果: 该模型随后通过人类反馈的强化学习进行了微调（RLHF）[40]。鉴于GPT-4等大规模模型的竞争格局和安全影响，本报告不包含有关架构（包括模型大小）、硬件、训练计算、数据集构建、训练方法或类似内容的进一步细节。我们致力于独立审计我们的技术，并在与此发布一同的系统卡中分享了一些初步的步骤和想法。我们计划向能够为我们权衡竞争和安全考虑与进一步透明度的科学价值之间的关系提供建议的其他第三方提供更多技术细节。可预测的扩展GPT-4项目的主要焦点之一是构建一个能够可预测地扩展的深度学习堆栈。主要原因是对于像GPT-4这样非常大规模的训练，进行广泛的模型特定调整是不可行的。为解决这个问题，我们开发了基础设施和优化方法，这些方法在多种规模下具有非常可预测的行为。
原文: These improvements allowed us to reliably
predict some aspects of the performance of GPT-4 from smaller models trained using 1;000–
10;000less compute.3.1 Loss Prediction
The ﬁnal loss of properly-trained large language models is thought to be well approximated by power
laws in the amount of compute used to train the model [41, 42, 2, 14, 15].To verify the scalability of our optimization infrastructure, we predicted GPT-4’s ﬁnal loss on our
internal codebase (not part of the training set) by ﬁtting a scaling law with an irreducible loss term
(as in Henighan et al.[15]):L(C) =aCb+c;from models trained using the same methodology
but using at most 10,000x less compute than GPT-4.This prediction was made shortly after the run
started, without use of any partial results.The ﬁtted scaling law predicted GPT-4’s ﬁnal loss with
high accuracy (Figure 1).3.2 Scaling of Capabilities on HumanEval
Having a sense of the capabilities of a model before training can improve decisions around alignment,
safety, and deployment.
翻译结果: 这些改进使我们能够可靠地预测使用1,000至10,000倍计算资源比GPT-4小的模型训练时，GPT-4性能的某些方面。3.1 损失预测大型语言模型的最终损失被认为可以用于训练模型所使用计算资源的数量的幂律来很好地近似描述[41,42,2,14,15]。为了验证我们的优化基础设施的可扩展性，我们使用最多比GPT-4少10,000倍计算资源但使用相同方法训练的模型（并非训练集的一部分）来拟合一个带有不可约损失项的缩放定律（如Henighan等人所述[15]）：L(C) =aCb+c;。在开始运行后不久，我们进行了这种预测，没有使用任何部分结果。拟合的缩放定律准确预测了GPT-4的最终损失（图1）。3.2 人类评估能力的缩放在训练之前了解模型的能力，可以改善对齐、安全和部署的决策。
原文: In addition to predicting ﬁnal loss, we developed methodology to predict
more interpretable metrics of capability.One such metric is pass rate on the HumanEval dataset [ 43],
which measures the ability to synthesize Python functions of varying complexity.We successfully
predicted the pass rate on a subset of the HumanEval dataset by extrapolating from models trained
with at most 1;000less compute (Figure 2).For an individual problem in HumanEval, performance may occasionally worsen with scale.Despite
these challenges, we ﬁnd an approximate power law relationship  EP[log(pass _rate(C))] = C k
2In addition to the accompanying system card, OpenAI will soon publish additional thoughts on the social
and economic implications of AI systems, including the need for effective regulation.2
翻译结果: 除了预测最终损失之外，我们还开发了一种方法来预测更可解释的能力度量标准。其中一种度量标准是对HumanEval数据集[43]的通过率，该数据集衡量了综合不同复杂度Python函数的能力。我们成功地通过从最多1,000次计算的模型中推断，在HumanEval数据集的一个子集上预测了通过率（图2）。对于HumanEval中的某个问题，性能偶尔会随着规模的增加而变差。尽管存在这些挑战，我们发现一个近似的幂律关系EP[log(pass_rate(C))] = Ck。
除了相应的系统卡片，OpenAI很快还将发表关于AI系统社会和经济影响的其他看法，包括需要有效监管的需求。
原文: Observed
Prediction
gpt-4
100p 10n 1µ 100µ 0.01 1
Compute1.02.03.04.05.06.0Bits per wordOpenAI codebase next word predictionFigure 1.Performance of GPT-4 and smaller models.The metric is ﬁnal loss on a dataset derived
from our internal codebase.This is a convenient, large dataset of code tokens which is not contained in
the training set.We chose to look at loss because it tends to be less noisy than other measures across
different amounts of training compute.A power law ﬁt to the smaller models (excluding GPT-4) is
shown as the dotted line; this ﬁt accurately predicts GPT-4’s ﬁnal loss.The x-axis is training compute
normalized so that GPT-4 is 1.Observed
Prediction
gpt-4
1µ 10µ 100µ 0.001 0.01 0.1 1
Compute012345– Mean Log Pass RateCapability prediction on 23 coding problems
Figure 2.Performance of GPT-4 and smaller models.The metric is mean log pass rate on a subset of
the HumanEval dataset.A power law ﬁt to the smaller models (excluding GPT-4) is shown as the dotted
line; this ﬁt accurately predicts GPT-4’s performance.
翻译结果: 观察值
预测值
GPT-4
100p 10n 1µ 100µ 0.01 1
1.02.03.04.05.06.0 计算1
单词位数开放AI代码库下一个单词预测图1.GPT-4和更小的模型的性能。度量的是从我们内部代码库派生的数据集上的最终损失。这是一个方便的、大型的代码令牌数据集，其中不包含训练集。我们选择查看误差，因为它往往跨不同训练计算量的其他指标更稳定。较小模型（不包括GPT-4）的幂律拟合显示为虚线；这个拟合准确地预测了GPT-4的最终损失。x轴是归一化的训练计算，使GPT-4为1。观察值
预测值
GPT-4
1µ 10µ 100µ 0.001 0.01 0.1 1
0、1、2、3、4、5、6 计算
位数012345平均登录通过率23个编码问题能力预测图2.GPT-4和更小的模型的性能。度量的是HumanEval数据集的平均登录通过率的子集。较小模型（不包括GPT-4）的幂律拟合显示为虚线；这个拟合准确预测了GPT-4的性能。
原文: The x-axis is training compute normalized so that
GPT-4 is 1.3
翻译结果: x 轴是训练计算的归一化值，使得 GPT-4 的值为 1.3。
