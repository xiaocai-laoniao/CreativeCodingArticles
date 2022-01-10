# Processing沙画的笔触模拟

在开篇中，小菜提到了沙画技法中的『漏』。

> 沙画技法中有一种方式叫『漏』，就是把沙子攥在手里并握紧拳头，靠拳头的松紧控制沙子的流量，线条会产生粗细的变化，同时在快速移动时，手的高低变化也会发生相应变化，此手法主要用来描绘图形。我们试试看能不能模拟出漏的感觉。

其实沙画的笔触模拟是非常复杂的，本篇我们来实现一个非常简单的笔触形式，也就是通过`randomGaussian()`来模拟沙子的笔触分布情况。

## 知识小课堂-正态分布

我们先看下官方文档：

>  从平均值为 0 且标准差为 1 的随机数系列返回浮点数。每次调用 randomGaussian() 函数时，它都会返回一个符合高斯或正态分布的数字。理论上，randomGaussian() 可能返回没有最小值或最大值。相反，返回远离平均值的值的概率非常低。并且返回平均值附近的数字的概率更高。

"能不能说人话，我有些看不懂。。。"

要理解这个函数，需要理解『正态分布』这个概念。正态分布在日常生活中很常见，比如某个国家成年男性身高的分布、一个健康人在一天当中血压的变化、高考数学成绩的分布，这些数据的背后都隐藏着一个正态分布模型。

**正态分布，就是在正常状态下的概率分布，而所谓分布，就是描述一组数中，有多少数是大，有多少数是小，这些大数和小数在整体中的占比又是多少。**

小菜做了两个关于正态分布的 DEMO，一起来看看：

「插入视频」

正态分布的整体图形曲线如下图：

<img title="" src="https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2022/01/09/20220109191856.png" alt="" data-align="inline">

描述正态分布，需要两个参数，一个就是**峰值的位置**，可以理解成一组数的平均值，一般用希腊字母 μ 表示，另外一个是分布的标准差，代表一组数的离散程度，一般用希腊字母 σ 来表示。

<img src="https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2022/01/09/20220109192315.png" title="" alt="" data-align="center">

举个很简单的标准差的例子，如何衡量一个 NBA 球员的战斗力？

在 NBA 中，平均数据用来衡量一个球员的战斗力，比如场均得分，盖帽，抢断，助攻等。 但是如果想知道哪位球员发挥最稳定该怎么办？在一些关键的比赛场合，你想要分高，且发挥稳定的球员，而不是表现时好时坏，水平忽高忽低，波动很大的球员。 

而标准差就是为了描述在一组数据中数据的波动大小而发明的。 

## Processing之randomGaussian()

Processing的`randomGaussian`返回的是从平均值为 0 且标准差为 1 的随机浮点数。通常我们在使用的时候，要乘以一个扩大的系数，假设为 scale，来获得一个从平均值为 0 且标准差为 scale 的随机数。

```java
size(400, 400);
for (int y = 0; y < 400; y++) {
  float x = randomGaussian() * 60;
  line(200, y, 200 + x, y);
}
```

<img title="" src="https://processing.org/static/f9bb318eaff04578f85c1d2336ce4f91/d6138/RandomGaussian_0.png" alt="Image output for example 1" data-align="center">

这个例子来自官方 api 文档的一个例子，从例子中可以看到

- for 循环绘制，一共绘制了 400 个线段，得到了一组满足正态分布的数值

- 线段的长度是由`randomGaussian()`乘以了 60 得到，这个值带了正负符号，平均值是0，标准差是 60

数学的东西，有时候不好理解。那么简单理解下，敲黑板了，划重点了：

**在 Processing 中，使用 randomGaussian() * scale 来获得一个满足正态分布的随机值，当然正态分布是建立在一组数据之上的分布，单独讨论一个数字是没有意义的，我们通常可以用一个 for 循环中使用`randomGaussian()`进行一组数据的生成。这组数据的大小分布规律，呈现两头低，中间高的特点。**

仅理解这点，就已经足够让我们在生成艺术中施展拳脚了。

## p5js中的randomGaussian

需要值得一提的是，Processing Java中的`randomGaussian`函数没有参数，默认是返回的平均值为 0，标准差为 1 的随机浮点数。

但在 p5js 中，`randomGaussian`可以携带 0 个或者 1 个 或者 2 个参数。它的函数签名是`randomGaussian([mean], [sd])`，其中 mean 代表平均值，sd 代表标准差。两者用 [] 中括号扩起来，代表是可选的，可带也可不带的意思。

- 不带参数，表示返回的平均值为0，标准差为1的满足正态分布的随机浮点数

- 带 1 个参数 mean，表示返回的平均值为 mean，标准差为 1 的满足正态分布的随机浮点数

- 带 2个参数 mean 和 sd，表示返回的平均值为 mean，标准差为 sd 的满足正态分布的随机浮点数

## 代码实现

终于到了代码实现环节了，完整代码如下：

```java
int batchSandCount = 600;
float sandRange = 10;

final color SAND_COLOR_1 = #AC9730;
final color SAND_COLOR_2 = #B79733;


void setup() {
  size(800, 800);
  background(255);
}


void draw() {
  if (!mousePressed) {
    return;
  }

  float mouseXSpeed = abs(mouseX - pmouseX);
  float mouseYSpeed = abs(mouseY - pmouseY);
  float mouseSpeed = max(mouseXSpeed, mouseYSpeed);
  mouseSpeed = constrain(mouseSpeed, 0, 100);
  sandRange = map(mouseSpeed, 0, 100, 10, 100);
  batchSandCount = int(map(mouseSpeed, 0, 100, 600, 1000));

  for (int i = 0; i < batchSandCount; i++) {
    float posx = randomGaussian() * sandRange;
    float posy = randomGaussian() * sandRange;

    if (random(1) < 0.5) {
      stroke(SAND_COLOR_1);
    } else {
      stroke(SAND_COLOR_2);  
    }
    point(mouseX + posx, mouseY + posy);
  }
}

void keyPressed() {
  if (key == 'c') {
    background(255);
  }
}
```

## 思路分析

声明下，以下思路仅小菜的一种思考实现方式，并不一定最好，但也算一种简单的模拟实现。

- 计算出鼠标的移动速度，取横向和纵向较大的速度，然后使用`constrain`函数限定移动的速度范围，防止过快的速度

- 我们模拟当手（鼠标）移动的速度和手中（笔触）沙子的数量成正比，当移动的越快时，手中流逝出的沙子数量就越多

- 我们模拟当手（鼠标）移动的速度和沙子的分布范围`sandRange`成正比，当移动的越快时，画布上的沙子分布的范围越大

## 源码地址

[Processing100天速写](https://github.com/xiaocai-laoniao/Processing100DaysSketch) 之 [Day_055](https://github.com/xiaocai-laoniao/Processing100DaysSketch/tree/main/Day_055)

---

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

小菜和小伙伴维护了一个 Processing 交流论坛：[https:/www.processing.love](https://www.processing.love)，欢迎读者朋友注册多多交流哈。

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在2022/01/17号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2022/01/09/20220109201316.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)
