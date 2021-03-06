# 一切伟大的事情都从编程和绘画开始

Hello，大家周末好哇！

今天小菜很高兴的和大家同步一件事情，那就是

**一个立志成为国内最大最好的 Processing 社区论坛正式建立并且已经发布啦！**

论坛地址：[https://www.processing.love](https://www.processing.love)。欢迎各位注册！

## 建立论坛的初衷

小菜在研究和分享 Processing 的过程中，通过 QQ 群、微信群链接到了不少朋友，有老师如一朵老师，有学生，有从业者，也有爱好者。而建立论坛的想法和渊源来自一位和小菜有着同样爱好 Processing 的朋友，小菜这里简称刘，对了，他还有一个很『low』的英文名，Peter，哈哈哈哈...

刘在上海工作，是一家海外公司的大前端 leader，因为工作原因，接触到了 P5.JS，也在学习的过程中，通过小菜的文章链接到了小菜。

我俩会偶尔探讨一些想法，有一天刘对小菜说，想建立一个社区，用来解决数字媒体相关学生、从业者、爱好者，在学习 Processing 的过程中，遇到的编程、数学以及实现思路问题。小菜否定了刘做 App 的想法，因为涉及到双平台 iOS、Android 的开发，即便用了跨平台 Flutter 技术，仍然有大量的工作要做，这不是我们两个人能承担过来的。

最终我们确定的形式是论坛。

我们一致的认为，目前的学习交流的几种方式主要有下面几种

- 加入 QQ 群
- 加入微信群
- 百度贴吧
- 豆瓣小组
- B 站视频
- 官方英文论坛[https://discourse.processing.org/（新论坛）](https://discourse.processing.org/)，[https://forum.processing.org/（旧论坛）](https://forum.processing.org/)

注意这里说的是交流哦，如果是自学，不涉及交流，不在此讨论范围:)

我们看下以上方式都有哪些问题？

- QQ 群和微信群面临最大的问题，就是控制不好的话，聊天吹水，噪音太多，讨论的话题或者问题解决方案很快就会被淹没，不能够有效的沉淀下来，这样会导致什么问题？同一类或者同一个问题被不同的人反复提问，也许有位好心人会花费时间来解答下，但最好的方式应该是给出引导和之前沉淀的讨论结果。

  时间是宝贵的，提问也应该是智慧的，在提问前利用搜索引擎来搜索关键字是一个很重要的技能，也是拉开两个人解决问题能力一个很重要的环节。而 QQ 群和微信群的信息，显然无法被搜索引擎搜索到，它们必须以公开的方式和形式，沉淀到外部世界中，而不是封闭的空间。

- 百度贴吧的问题是啥？问题大了，糟糕的文本编辑体验，满天飞的广告和作业代做，无人回答的一篇又一篇帖子，这个真是一言难尽，用过的人都知道。

- 豆瓣小组比较小众，讨论的人少，帖子陈旧，不够活跃，作业代做也是满天飞，且帖子类型没有标签分类，给真正想讨论问题、解决问题的人塑造了一个无形的墙壁，让人看到就不禁想关闭掉网站，豆瓣，也许要被时代抛弃。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/20/20211120095354.png)

- B 站视频：不得不说 B 站上有很多 Processing 优秀的教程和作品分享，但这个毕竟不一个专门讨论问题的地方，观看者和阿婆主通过评论互动，天然决定了信息的沉淀和检索是一个问题，而且彼此之间的讨论，其他人不能够有效的知晓和参与进来
- 官方英文论坛，这个论坛也是我们的目标和方向，有不少帖子质量非常高，小菜在上面学习到很多，但受限于语言层面一些交流的问题，我们需要本土化一个论坛，作为补充，用来解决国内用户的交流和学习问题



## 建立论坛的过程

刘作为发起人，我们一起讨论了论坛如何搭建的问题，最终确认使用了开源论坛[flarum](https://flarum.org.cn/)。这个开源论坛在 github 的 star 数相当高，且一直很活跃，关键的一点是插件生态非常丰富，且论坛颜值很能打。😄

从云服务器的购买和系统搭建，都是刘一手搞定的，经过陆续几天的完善，刘添加了一些常用的功能，如

- 中文昵称
- 移动端的适配，底部 tabbar 的显示
- 论坛热门统计
- 全局通知栏
- 对用户或者话题进行关注
- 在讨论列表中显示摘要
- 发帖内容优化，可以识别以下 Niconico, ACFUN, Bilibili, Xiami music, Netease cloud music 等平台的音视频，目前验证了 B 站视频，其他平台待验证
- 网站的 SEO 搜索优化
- 最重要最重要的一点是支持中文搜索

至此，一个成熟的论坛系统已经基本就位。

但遗憾的是，因为备案问题，我们无法对接七牛云腾讯云存储服务，所以目前发帖，如果要带上图片，需要使用图片外链的形式，了解  Markdown 的读者对此可能不陌生，`![这是我要显示的图片的文字说明](https://www.xxx.com/xxx/xxx.jpg)`这样的形式便可以将图片显示出来。我们理想的形式是接入云存储，用户在发帖的时候，直接上传本地的图片或视频，但目前先委屈大家图片使用三方图床的形式，链接过来显示。视频的话，通过嵌入如 B 站视频或者链接的形式跳转到其他网站进行展示说明。这一点，目前很遗憾，我们还在想办法解决。

关于发帖带上图片、视频的的用法，刘会单独开一篇置顶帖子做个教程使用说明。



## 论坛的现状

目前经过讨论，我们将论坛划分出如下版块，这些版块其实也是一个大的标签，讨论的帖子基本离不开这些主题，好处非常明显，我们可以聚焦在某个主题，进行浏览。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/20/20211120142007.png)


简要说下

- Processing、p5.js、Processing for Python、Processing for Android 4 个模块参照的官网的模块划分，不用的语言和场景有一些代码、硬件交互等方面的不同，还是有必要各自独立开，分开进行讨论。
- Arduino，这块是硬件 Arduino 方向的讨论
- 数学基础，Processing 的图形表现离不开很多数学基础，该版块用来讨论一些数学问题
- 作品分享，作品无论好坏，鼓励大家分享，互相交流，目前可以发链接、A 站、B 站视频等。
- 艺术基础，讨论一些艺术方面的知识，艺术如何为 Processing 加持
- 学习资源，该版本用来推荐一些网站、书籍等
- 意见反馈，用户可以在该版块提出对论坛的一些改进意见等
- 实用工具，我们在学习 Processing 的过程中，那些好用的工具
- 公告，用于展示论坛的一些信息公告，如论坛的一些使用说明等等



## 建立论坛的期望

我们期望将论坛建设成什么样子？

- 国内最大的 Processing 社区论坛
- 吸引爱好者、学习者、从业者等入驻论坛，参与问题讨论、回答，以及知识分享和作品分享等
- 有着良好的学习和交流氛围



我们不欢迎论坛出现：

- 广告
- 寻找作业代做，无论是人找作业，还是作业找人。如果有，可以通过其他途径，但我们不希望出现在这里

如果出现这样的帖子，肯定会被删帖，因为根据多年的经验，这种帖子会让高质量的用户流失掉，良币被驱逐，论坛就无法提供好的内容支撑和回答交流，从此以往，就会沦为贴吧一样的地步，这也是刘和小菜一起达成的共识，也期望未来加入的大伙能够遵守这条规则。


世界因分享而美好，生命因分享而充实！为爱发电的 https://www.processing.love 扬帆起航！


---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在 2021/11/27 号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/20/20211120111236.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)

