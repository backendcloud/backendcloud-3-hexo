---
title: ChatGPT 和 Dall-E 2 合作为中国古诗加入图像元素
readmore: false
date: 2023-04-06 12:50:56
categories: Tools
tags:
---

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

叶绍翁《游园不值》
应怜屐齿印苍苔，小扣柴扉久不开。
春色满园关不住，一枝红杏出墙来。

人类：
春色满园关不住，一枝红杏出墙来。

ChatGPT：
/imagine prompt: The spring scenery fills the entire garden, bursting with life and vitality. An auspicious branch of red apricot pushes through the garden wall, eager to join the beauty outside. Despite being confined within the garden walls, the natural beauty of spring cannot be contained and spills over these boundaries, bringing joy and delight to all that witness it.

![](/images/poetry/2.png)

人类：
柳宗元《江雪》
千山鸟飞绝，万径人踪灭。
孤舟蓑笠翁，独钓寒江雪。

ChatGPT：
/imagine prompt: Birds are gone from the thousand mountains, and the paths show no signs of human travel. An aging fisherman sits alone on his lone boat, wearing a straw raincoat and a bamboo hat, and casting his lonely line into the icy waters of the river. Despite the bitter cold of winter and the desolation of nature, the fisherman remains undeterred, braving both the weather and the solitude to undertake his daily task.

![](/images/poetry/3.png)

> 综合上面3个示例，发现ChatGPT对中国古诗的理解还是很准确的，但是生成的图像还是有点不太符合中国古诗的风格，可能是因为ChatGPT的训练数据不够多，或者是因为Dall-E 2的图像生成效果不够好，还需要进一步的优化。从理解古诗文上，就是一个以中文为母语的普通人，不经过一定的阅读训练，是很难理解古诗文的，但是ChatGPT却可以很好的理解古诗文，这就是ChatGPT的强大之处。