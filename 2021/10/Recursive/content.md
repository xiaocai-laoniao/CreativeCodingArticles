# 生成艺术之递归-小白也能看的懂系列


![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/fractal-1119594_1280.jpeg)

## 前言

Hello，大家好，今天小菜带大家伙来详细认识下生成艺术中用到的递归思想。

为啥突然来讲这个主题，源自于小菜的交流群中有朋友问到了一个效果的实现思路，这个效果在[https://www.patrik-huebner.com/ideas/60s-swiss-recursive-poster-series/](https://www.patrik-huebner.com/ideas/60s-swiss-recursive-poster-series/)这里。它的具体效果是这样的：

【插入视频号视频】

小菜之前也没想到是怎么实现的，但一看比较眼熟，之前在浏览 openprocessing 的时候见过类似的实现。找了一番，原来是 Sayama 大神的一个作品，链接是 [https://openprocessing.org/sketch/1121603](https://openprocessing.org/sketch/1121603)。

在 openprocessing 上 fork 了大神一份代码，进行修改理解，做了一个类似的效果，带上了随机的数字部分。

【插入视频号视频】

这个效果的实现，使用了递归绘制的思想，同时结合目标位置的缓动效果便可实现。一篇文章讲的话，实在太长，今天我们就从递归谈起。



## 递归的奥妙

究竟什么是递归？递归，递归，从表面看，就是一个函数在实现中，会再次调用本身。

这里有一个非常简单明了的例子，来自公众号「pipi的奇思妙想」。[pipi的奇思妙想：递归](https://mp.weixin.qq.com/s/1b5LLleRmdZdTa0iqpHYuw)

> 电影院里，有人问你你坐在第几排，你懒得数，于是你问坐在你前一排的人他坐在第几排，这样在他回答的排数上加1你就可以知道你坐在第几排了。坐在你前一排的人也懒得数，于是就继续去问坐在他前一排的人相同的问题，这样一直下去直到问到坐在第一排的老哥，第一排的老哥当然会告诉你他坐在第一排。于是这个消息会从第一排开始一排一排再传回到你这里，当然每个接受到这个消息的人会在这个结果上加1再把结果传给后排的人，于是你就可以得到你在第几排啦~~
>
> 
>
> 例子解析：
>
> 1.坐在第几排的问题，可以转化问题为：**在我前面有多少人+1**;
>
> 2.这个比喻形象地说明了递归对于堆栈的调用，一层层压入堆栈（从提问者的位置到第1排的位置）以及弹出堆栈（从第1排到算出提问者排数）的过程。



小菜画了一张图，一起来直观感受下：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/cinema_example.png)



图中的`f`代表着一个函数，这个例子用中文来表述，就是`我是第几排`这样的函数，参数是我的编号（编号从第4排观众往后依次递增1），需要注意的是，这个递归结束条件是编号为1的观众知道自己坐在了第4排。那么这个递归函数就可以用代码这么描述：

```java
int rowOfMe(int number) {
  if (number == 1) {
    return 4;
  }
  
  return rowOfMe(number - 1);
}
```

**递归的两个过程，就是『递』和『归』。『递』就是每次函数的调用，都是基于上次函数调用，从而实现调用的传递，『归』就是当遇到终止条件，从最后一级一级将结果代入进去再计算回溯回来。**



所以敲黑板了，实现一个递归有着非常重要的3个步骤：

1）必须非常清楚的了解到函数的作用，比如电影院的例子是『我在第几排』

2）找到终止条件。我们需要在自身调用自身这个过程中，通过终止条件，结束『递』的过程，然后回到『归』的过程。

3）找到重复的逻辑，也就是递归公式，比如电影院的例子是`f(n) = f(n - 1) + 1`。



Input 就是传递，将递归调用逐步向终止条件靠近，其实也是将问题逐渐缩小，到达终止条件后，再 Output 进行回归。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/13/20211013162711.png)


## 从前有座山

从前有座山，山上有座庙，庙里有个老和尚，一天老和尚对小和尚讲故事，故事是这样的：从前有座山，山上有座庙，庙里有个老和尚，一天老和尚对小和尚讲故事，故事是这样的：...

```java
void aStory() {
	从前有座山
	山上有座庙
	庙里有个老和尚
	一天老和尚对小和尚讲故事
	故事是这样的:aStory()
}
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016134855.png)


## 一些有趣的图片

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016132533.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016134056.png)

![分形树](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016132607.png)

![你吃的就是你自己](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/4311634275649_.pic_hd.jpg)


![小菜的OBS采集画面](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016092144.png)



## Processing 例子

### 例子1-阶乘

在数学中，我们要计算一个数的阶乘，上学的时候学过公示：

- n! = n * (n - 1) * ... * 3 * 2 * 1
- 0! = 1

如果用程序写，我们的常规思路是不使用递归的写法

```java
int factorial(int n) {
  int f = 1;
  for (int i = 0; i < n; i++) {
    f = f * (i + 1);
  }
}
```

但仔细观察，我们便知道`n 的阶乘可以被定义为 n 乘以 n - 1 的阶乘`

- n! = n * (n - 1)!
- 1! = 1

我们换成递归的写法，终止条件是 1 的阶乘是 1。

```java
int factorial(int n) {
  if (n == 1) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/fractorial.jpg)



### 例子2-递归圆

```java
int index = 0;
void setup() {
  size(800, 800);
}

void draw() {
 	background(255);
  drawCircle(width / 2, height / 2, width);
}

void drawCircle(int x, int y, float d) {
  if (d < 120) {
    return;
  }

  noFill();
  circle(x, y, d);
  fill(255, 0, 0);
  text(index, x + (d / 2 - 10) * cos(0), y + (d / 2 - 10) * sin(0));
  index += 1;

  drawCircle(x, y, d * 0.75);
}
```

个人理解，对于 Processing 图形绘制而言，最简单的入门图形就是递归圆的绘制了。

从递归圆的绘制中，我们能学到在 Processing 如何使用递归去绘制图形。

首先，我们按照递归三步骤来：

1）必须非常清楚的了解到函数的作用。这里函数就是绘制圆，参数会传入圆的圆心坐标和圆的直径大小。

2）找到终止条件。我们可以让圆的直接小于某个阈值的时候，停止递归。

3）找到重复的逻辑，也就是递归公式，这里就是`drawCircle(x, y, d * 0.75)`，也就是我们在递归的时候按照`0.75`的比例不断缩小圆的直径。所以读者可以发挥想象力，在递归的时候进行修改圆心坐标也会得到非常有趣的递归图形。

我们在递归绘制的时候，为了区分出圆绘制的顺序，给每个圆加了个编号，用来标识出圆依次绘制的顺序。注意看上面代码的绘制结构：

```java
void drawCirlce(int x, int y, float d) {
 	// 1. 终止条件
  
  // 2. 绘制部分 放在递归前的代码
  // 3. 递归调用 drawCircle(x, y, d * 0.75);
  // 4. 绘制部分 放在递归后的代码 （暂无）
}
```

我们可以总结下，Processing 使用递归思想绘制的函数的核心写法就是 4 大步骤，也就是思维套路，分别为

- 1.终止条件
- 2.放置在第3步递归调用之前的绘制代码
- 3.递归调用
- 4.放置在第3步递归调用之后的绘制代码

具体写法可能稍微不同，但都脱离不了这个范围。

那么重点问题来了，理解这点很重要，第 2 步骤和第 4 步骤有什么不同呢？他们处于递归调用的前后位置，会导致什么样的区别？

代码对比是下面这样：

```java
// 代码例子1：放置在递归调用前面的绘制
void drawCircle(int x, int y, float d) {
  if (d < 120) {
    return;
  }

  // 放置在前面
  noFill();
  circle(x, y, d);
  fill(255, 0, 0);
  text(index, x + (d / 2 - 10) * cos(0), y + (d / 2 - 10) * sin(0));
  index += 1;

  drawCircle(x, y, d * 0.75);
}

// -----------------------------------

// 代码例子2：放置在递归调用后面的绘制
void drawCircle(int x, int y, float d) {
  if (d < 120) {
    return;
  }

 
  drawCircle(x, y, d * 0.75);
  
  // 放置在后面
  noFill();
  circle(x, y, d);
  fill(255, 0, 0);
  text(index, x + (d / 2 - 10) * cos(0), y + (d / 2 - 10) * sin(0));
  index += 1;
}
```

先说结论，对比如下面两张图，第一张绘制代码在递归调用函数前面，从外到内绘制，第二张绘制代码在递归调用函数后面，绘制圆的顺序则是从内到外。神奇不？

**第 2 步骤即递归调用函数前面的绘制代码，每次在递归调用的时候，会被先执行，也就是『递』的执行过程，而第 4 步骤的代码，则会在『归』的时候执行。** 读者可以用纸和笔绘制下，亲自感受下。



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016120429.png)





![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/20211016120514.png)





## 例子3-递归矩形盒子

我们这里先不使用面向对象的方式进行递归绘制，代码在[](https://github.com/xiaocai-laoniao/OpenProcessingSourceCodeAnalysis/blob/master/1286327/step1.js)。

【插入视频号】

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/16/box.png)



这样，离文章开头视频效果，还差几个效果：

1. 格子切割比例动态设定，按照目标比例进行缓动
2. 文字变形缩放部分

这两个实现将会在下篇文章中介绍，递归绘制部分将使用面向对象的方式，方便每个格子保存自身属性数值，如切分比例 ratio 等。




---------
小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/09/25/640.gif)









