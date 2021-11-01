# Processing之完美循环的艺术

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/29/loop_gif.gif)

【插入公众号卡片】

## 前言

我们经常在社交网站上会看到一些生成艺术使用的视频或者 GIF 展示，不过不知道读者有没有仔细观察过有些视频和 GIF，他们的开头和结尾是无缝衔接的，或者说在某个时间点又开始重复循环。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/v2-9df925839372305ba8011c32a9647c20_720w.gif)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/082004506653125.gif)



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/082004445404430.gif)

小菜在 Tumblr 浏览时无意中翻到了作者 necessary-disorder 的作品，颇为喜欢，他的作品基本都是这种无限循环风格。

【插入视频号】



## 如何做出完美循环？

完美循环最重要的一点就是“将来能够在某个时刻，能够再次展现开始帧”。如果我们给开始帧画面打个标记 A，那么不管我们的动画经过怎么变化，只要中间能够再次绘制 A 帧画面，就能够实现完美循环。



## Processing中的处理方式

这个就涉及到了今天小菜要给大家分享的主题，就是『完美循环 GIF 输出』。不仅仅要实现完美循环，还要输出成 GIF。这块内容也是小菜观看 [Shiffman 的教学视频](https://www.youtube.com/watch?v=nBKwCCtWlUg)的一个文字总结和分享，希望对大家有所帮助。

教学中提到了一个 github 开源项目，[LoopTemplates](https://github.com/golanlevin/LoopTemplates)，这个项目里面展示了如何使用 Processing Java、p5.js、Processing Python 来创建一个完美循环 GIF，算是一个模板 Template，结合我们的想法，会轻松的做出完美循环 GIF 动画。

### 思路

```java
// loop动画所需要的帧数
int nFramesInLoop = 120;
// 随着时间已经流逝、播放的帧数
int nElapsedFrames;
// 是否正在录制
boolean bRecording; 

void setup() {
  size (500, 200); 
  bRecording = false;
  nElapsedFrames = 0;
}

void draw() {
  // 计算loop动画进度的百分比值(0到1)
  float percentCompleteFraction = 0; 
  if (bRecording) {
    percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;
  } else {
    percentCompleteFraction = (float) (frameCount % nFramesInLoop) / (float)nFramesInLoop;
  }


  // 基于这个loop进度进行绘制
  renderMyDesign (percentCompleteFraction);

  // 如果处于录制中，则保存序列帧图片
  if (bRecording) {
    saveFrame("frame_" + nf(nElapsedFrames, 4) + ".png");
    // 增加loop播放的帧数
    nElapsedFrames++; 
    // 如果达到了一个循环，则停止录制
    if (nElapsedFrames >= nFramesInLoop) {
      bRecording = false;
    }
  }
}

// 一个由 0 - 1 的小数，驱动的绘制
void renderMyDesign (float percent) {
  
}

// 按键事件
// f / F 键触发录制
void keyPressed() {
  if ((key == 'f') || (key == 'F')) {
    bRecording = true;
    nElapsedFrames = 0;
  }
}
```

1）当按下键盘 f 或者 F 键时，开始录制，设定`bRecording`布尔值为`true`，以及`nElapsedFrames`流逝的帧数归置为0。

2）在每帧绘制的时候，我们要计算出一个 loop 动画的进度完成比，`percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;`。

3）我们根据这个动画完成比进行自定义动画实现

4）录制的时候，使用`saveFrame`保存帧画面成序列图到本地，同时`nElapsedFrames`递增1，当`nElapsedFrames`大于等于我们规定的一个 loop 动画帧总数，那么便停止录制，设定`bRecording = false`。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/29/loop_gif.gif)

比如在`renderMyDesign(float percent)`中根据循环动画进度完成比，来实现上面 GIF 中的方块自旋和小圈围着方块中心旋转的循环逻辑：

```java
void renderMyDesign (float percent) {
  background (180);
  smooth(); 
  stroke (0, 0, 0); 
  strokeWeight (2); 


  float cx = 100;
  float cy = 100;
  

  float radius = 80; 
  // 根据循环动画的进度计算圆旋转的角度
  float rotatingArmAngle = percent * TWO_PI;  
  float px = cx + radius*cos(rotatingArmAngle); 
  float py = cy + radius*sin(rotatingArmAngle); 
  fill    (255); 
  line    (cx, cy, px, py); 
  ellipse (px, py, 20, 20);


  pushMatrix(); 
  translate (cx, cy);
  // 根据循环动画的进度计算方块自旋的角度
  float rotatingSquareAngle =  percent * TWO_PI * -0.25;
  rotate (rotatingSquareAngle); 
  fill (255, 128); 
  rect (-40, -40, 80, 80);
  popMatrix(); 
 
  // ...
}
```

## GIF 合成

关于 GIF 导出这块，我们有了之前的序列图，就容易多了。小菜推荐两个 GIF 制作网站，只需要把序列图上传上去，设定好动画帧速度，还可以设置循环次数（默认0为无限次），即可导出。当然，一些朋友可能习惯使用 Photoshop 来处理下，都是可以的。

- [https://gifmaker.me/](https://gifmaker.me/)
- [https://ezgif.com/maker](https://ezgif.com/maker) Shiffman视频中提到的，但小菜个人感觉没有上面的好

![gifmaker.me](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/29/20211029131835.png)

有一个[专门分享 loop gif 的网站](https://giphy.com/explore/perfect-loop)，读者朋友感兴趣可以戳一下，很不错哦。不过有些 loop 是完美的，第一帧和最后一帧是衔接的，有些不是。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/29/loop_gif2.gif)





## 更多精彩玩法

下面的代码来自[processingperfectloops/](https://bjango.com/articles/processingperfectloops/)，这篇文章给了小菜很多启发。

不知道大家伙有没有注意到在上面的模板代码中，当`bRecording`为`false`的时候，计算动画完成比的公式。

```java
if (bRecording) {
	percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;
} else {
	percentCompleteFraction = (float) (frameCount % nFramesInLoop) / (float)nFramesInLoop;
}
```

这就是`frameCount`在循环动画中的作用。

1）`frameCount % nFramesInLoop`：除法取余操作，保证得出来的值在`0 - (nFramesInLoop - 1)`范围内

2）`(float) (frameCount % nFramesInLoop) / (float)nFramesInLoop`：上步骤1取余得到的值再除以循环帧总数，则将最后的值归一化，限定在了`0 - 1`之间。



我们可以将计算百分比的方式抽象成一个函数，这个函数从`draw`的次数也就是绘制帧的次数这个角度表达出的意思就是**我希望这个循环动画在nFramesInLoop帧数中完成，每次draw的时候函数返回我动画0-1的进度**。如果我们在`setup`中使用`frameRate(value)`函数设定了帧数，即一秒钟绘制的帧数，那么从时间角度来说就是**我希望这个循环动画 nFramesInLoop / value 秒内完成**。

```java
float timeLoop(int nFramesInLoop) {
  return (float)(frameCount % nFramesInLoop) / (float)nFramesInLoop;
}
```



### 例子1：一个从左到右在屏幕中来回运动的方块

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop1.gif)

```java
void setup() {
  size(704, 90);
  frameRate(30);
}

void draw() {
  background(0);
  fill(255);
  rect(timeLoop(60) * width, height / 2, 40, 40);
}

float timeLoop(float nFramesInLoop) {
  return frameCount % nFramesInLoop / nFramesInLoop;
}
```

我们希望方块在 60 帧内，位置 x 坐标从 0 运动到 width 大小，因为帧率是 30帧/秒，也就是方块在 2 秒内从左到右完成一次动画循环。

### 例子2：时间错位

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop2.gif)

单个方块从左到右循环有些枯燥和乏味，如果绘制了多个方块呢？如何让多个方块之间有一种时间差的运动？也就是时间错位。

在`timeLoop`中我们引入另外一个参数`offset`用来增加一个偏移量，我们来看下这个代码：

```java
void setup() {
  size(704, 150);
  frameRate(30);
}

void draw() {
  background(0);
  fill(255);
  rect(timeLoop(60, 0) * width, 30, 30, 30);
  rect(timeLoop(60, 20) * width, 60, 30, 30);
  rect(timeLoop(60, 40) * width, 90, 30, 30);
}

float timeLoop(int nFramesInLoop, float offset) {
  return (float)((frameCount + offset) % nFramesInLoop) / (float)nFramesInLoop;
}
```



### 例子3：高度循环

一个`timeLoop`返回值的`0-1`的循环，不仅仅可以用于例子1和2中的**位置的变化**，也可以用于更多数值的变化，比如**大小的变化，如高低长宽等**。当然，这个可以用在任何想要循环的数值上。在这个例子中，我们赋予单个竖条矩形的高度的变化（从 0 到 100，然后突变到 0，继续开始从 0 到 100），然后再赋予竖条方块时间错位，形成下面的动态：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop3.gif)

```java
void setup() {
  size(704, 200);
  frameRate(30);
  noStroke();
}

void draw() {
  background(0);
  fill(255);
  background(0);
  for (float i = 0; i < 1; i += 1 / 16.0) {
    float barheight = timeLoop(60, i * 60) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
  }
}

float timeLoop(float nFramesInLoop, float offset) {
  return (frameCount + offset) % nFramesInLoop / nFramesInLoop;
}
```

### 例子4：缓动曲线

到目前为止，所有动画都以线性方式移动——对于每一帧，移动的距离是相同的。线性计时非常机械化，也不是特别优雅。
鉴于我们正在处理归一化值，可以应用缓动曲线。 `timeLoop`的结果只需要通过所需的曲线即可。下面的函数将锯齿波（线性时序）转换为三角波。这将使我们的方块上下移动，而不仅仅是向上移动。

小菜绘制了一些原理图，帮助读者彻底理解这里的函数叠加变换过程。

下图是`timeLoop`函数随着`frameCount`的递增，它的函数图形，可以看到图形是一个锯齿波形，从 0 到 1 后，又重新从 0 到 1，两个周期的值不是衔接的，从 1 跳变为 0。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop.001.jpeg)



那我们来看下`tri`函数

```java
float tri(float t) {
  return t < 0.5 ? t * 2 : 2 - (t * 2);
}
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop.002.jpeg)

`tri`函数的入参取值范围是`0-1`的值，在`0-0.5`区间，实现了函数返回值`0-1`的变化，而在`0.5-1`区间，实现了函数返回值`1-0`的变换。

那么将两个函数叠加起来呢？也就是`nFramesInLoop`作为`timeLoop`的入参，`timeLoop`的返回值又作为`tri`函数的入参，形式如

```java
tri(timeLoop(nFramesInLoop))
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop.003.jpeg)

两个函数的叠加，完美实现了在时间维度（frameCount）上的`0-1，1-0`的线型返回通道。



我们再看下`inOutSin`函数：

```java
float inOutSin(float t) {
  return 0.5 - cos(PI * t) / 2;
}
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop.004.jpeg)

`inOutSin`的入参是`0-1`，它的返回值在`0-1`范围内，一个非常完美的函数，实现了`0-1`区间的输入和`0-1`区间的输出这样一个正弦曲线。



我们玩点大的，将三个函数叠加到一起，`inOutSin(tri(timeLoop(nFramesInLoop)))`：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop.005.jpeg)

哇塞，真是完美，完美实现了在时间维度(frameCount)上，输出值的`0-1, 1-0`的正弦缓动变化。



所以总结下，`timeLoop`和缓动函数都是标准化的，它们可以按任何顺序组合。下面的更改采用`timeLoop`的结果，使其成为三角波，然后使其具有缓入缓出正弦时序。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop4.gif)

```java
void setup() {
  size(704, 200, P2D);
  frameRate(30);
  noStroke();
}

void draw() {
  background(0);
  for (float i = 0; i < 1; i += 1 / 16.0) {
    float barheight = inOutSin(tri(timeLoop(60, i * 60))) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
  }
}

float timeLoop(float totalframes, float offset) {
  return (frameCount + offset) % totalframes / totalframes;
}

float tri(float t) {
  return t < 0.5 ? t * 2 : 2 - (t * 2);
}

float inOutSin(float t) {
  return 0.5 - cos(PI * t) / 2;
}
```



### 例子5：更多的变化

如果我们再添加两个重复的竖条，添加一些颜色，并将绘制的混合模式设置为“添加”，画面看起来就更加丰富了！

```java
void draw() {
  background(0);
  blendMode(ADD);
  float barheight = 0;
  for (float i = 0; i < 1; i += 1 / 16.0) {
    fill(#ff0000);
    barheight = inOutSin(tri(timeLoop(60, i * 60))) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
    fill(#00ff00);
    barheight = inOutSin(tri(timeLoop(60, i * 60 + 20))) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
    fill(#0000ff);
    barheight = inOutSin(tri(timeLoop(60, i * 60 + 40))) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
  }
}

```



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/loop5.gif)



## 结尾

最后来个轻松点的无限循环，套娃模式

【插入视频号】

---------
小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在2021/11/7号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/WechatIMG442.jpeg)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/09/25/640.gif)