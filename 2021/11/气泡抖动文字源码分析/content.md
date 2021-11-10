

# processing文字气泡抖动源码分析篇



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106144355.png)

【插入视频号】

亲爱的读者朋友们，周末好哇。

今天小菜的`#processing源码分析系列`给大家带来的是一个文字气泡抖动的效果实现原理解析。对了，`#processing源码分析系列`已经出了两期

<img src="https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106114605.png" />

本期的效果和源码实现来自 openprocessing 的[Could Text by Richard Bourne](https://openprocessing.org/sketch/1231442)。

OK，话不多说，Let's go！



## 思考环节

**反复观察**最后的作品效果，如果要我们自己来实现，首先我们要问以下几个问题：

（1）气泡是在文字的路径上的，文字的路径信息或者或者坐标信息怎么获取到呢？

（2）这么多的气泡用的是粒子的设计思路么？

（3）粒子该怎么绘制？一个粒子是有两层圆形，背景层黑色，前景层白色，真的是这样吗？

（4）一直在不停的动是怎么实现的？并且这些粒子无论怎么动都不跑出字体的路径范围，如何实现呢？

我们来带着这些疑问来分析下源码。

## 气泡文字路径的获取

在 Processing 中我们如果要获取文字的像素坐标位置，有几个常见的做法，小菜列举下，如果有更多更好的做法，亲爱的读者朋友们，别忘记留言让小菜看到:)

### 1）文字顶点法

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106160245.png)

```java
PFont font;
ArrayList<PVector> edgeVertices = new ArrayList<>();

void setup() {
  size(600, 600);
  font = createFont("STHeiti", 260);
  PShape shape = font.getShape('菜');

  for (int i = 0; i < shape.getVertexCount(); i++) {
    edgeVertices.add(shape.getVertex(i));
  }
}

void draw() {
  background(255);

  translate(width / 2 - 139, height / 2 + 78);
  strokeWeight(2);
  beginShape();
  for (PVector v : edgeVertices) {
    vertex(v.x, v.y);
    circle(v.x, v.y, 8);
  }
  endShape();
}
```

这个方式的思路：

- 通过`PFont`的`getShape(char c)`获取到字体的`PShape`
- 通过`PShape`的`getVertexCount()`获取到所有顶点的个数，通过`getVertex(index)`获取到第index顶点的坐标的信息，将他们存储到数组中
- 遍历数组，结合`beginShape`和`endShape`，使用`vertex`将顶点绘制出来

呃...怎么说呢？这个方式获取的是字体轮廓上点，我们这个例子使用这个方式并不是很合适，因为有很多泡泡会出现在字体轮廓的内部。

### 2）文字图片法

文字图片法和文字输入法的原理都一样。但做法稍微有些不同。文字图片法是加载了一张字体图片，白底黑字最好啦。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/xiaocai.png)

我们获取到图片的像素信息，画上红色矩形，进行周期正弦波动的大小变化。
![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/Day_038.gif)
```java
PImage logoImage;
PShape logoShape;

void setup() {
  size(800, 200);

  logoImage = loadImage("xiaocai.png");
  float ratio = logoImage.height / logoImage.width;
  logoImage.resize(800, int(800 * ratio));

  noStroke();
}


void draw() {
  background(255);

  translate(0, height / 2 - 120);
  logoImage.loadPixels();
  for (int i = 0; i < logoImage.height; i++) {
    for (int j = 0; j < logoImage.width; j++) {
      color c = logoImage.pixels[i * logoImage.width + j];
      if (isFontPixel(c)) {
        fill(255, 0, 0);
        rect(j, i, sin(frameCount * 0.1) * 2 + 4, sin(frameCount * 0.1) * 2 + 4);
      } else {
        fill(255);
      }
    }
  }
}

boolean isFontPixel(color c) {
  //return dist(red(c), green(c), blue(c), 0, 0, 0) < 10;
  return red(c) < 5;
}
```

这个方式的思路：

- 推荐加载白底黑字的文字图片，保存到一个`PImage`对象中
- image 进行 loadPixels，然后双层遍历 image 的高宽，获取到 image 的每个像素颜色信息
- 颜色信息与图片中文字的黑色进行比较，如果很接近，小于一定的阈值，就认为这个像素是黑色字体所在的像素。判断的方式有很多种，可以用 dist 函数判断颜色的距离， dist(颜色1的red值，颜色1的green值，颜色1的blue值，颜色2的red值，颜色2的green值，颜色3的blue值) 如果小于比如 10，就认为俩颜色很相近了，或者干脆简单点，因为我们的字体就是单色嘛，直接取红色通道 red 的值，小于 5 就是黑色色块了。
- 如果是黑色字体的像素，那么画一个红色矩形方块
- 如果不是黑色字体的像素，啥也不干

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106174924.png)

**为什么要这么判断？因为字体放大后，我们可以看到边缘，并不是完全的黑色，而是具有一定的灰度，这种边缘的处理，使得字体在正常的情况下，视觉上看着就更加平滑。所以在白底黑字的情况下，我们一般不直接判断 red(color) == 0 来判断是否是字体的像素，而是给了一定的阈值，这样就会囊括一部分边缘像素。**

- 3）文字输入法

文字输入法也是作者使用的方法。和图片输入法略有不同的是，是直接将文本显示在画面中，然后通过`loadPixels`的方式来进行相似的处理。

```java
font = createFont("STHeiti", 260); // 创建黑体字体
  textFont(font); // 设定字体
  fill(0); // 字体填充为黑色
  textAlign(CENTER, CENTER); // 设定字体的对齐模式，水平居中，垂直居中
  text(typedText, width/2, height/2 - 70); // 显示字体
  typedText = "";
  inputText = "";

  count = 0; // 粒子个数从 0 开始
  // 小菜：注意这里是 width * heigh，其实正确的应该用 pixelWidth * pixelHeight，因为默认像素密度 pixelDensity 为 1
  // 见公众号文章：https://mp.weixin.qq.com/s/tdwM-mK3kDTSyMHZzgghig
  list = new int[width*height];

  loadPixels(); // 加载像素数据
  for (int y = 0; y <= height - 1; y++) {
    for (int x = 0; x <= width - 1; x++) {
      color pb = pixels[y * width + x]; // 通过（y * width + x）得到坐标（x，y）在 pixels 数组中的索引位置，获取坐标（x，y）的像素的颜色

      // 颜色的归一化操作！！！
      // 画布背景色为 BG_COLOR，文字颜色是黑色，此时像素颜色的红色通道值小于5，只能是文字的黑色
      // 也就是通过 red(pb) < 5 来简单快速的判断出文字所在的像素，将这些像素在list数组中的位置的数值都标记成0-黑色
      if (red(pb) < 5) {
        list[y * width + x] = 0;
      } else {  // 背景色，都标记成1
        list[y * width + x] = 1;
      }
    }
  }
  updatePixels(); // 更新像素
```

## 气泡粒子的设计

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106175539.png)

我们来观察下“小”字。

最开始小菜在看到效果的时候，以为单个气泡粒子 Particle 的绘制是这样的：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106175943.png)

粒子的绘制分成了黑色背景层和白色前景层，但一想不对啊，如果单个粒子是这么绘制的，那么他们接触叠加的时候应该是这样的：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/image-20211106180036914.png)

但结果并不是，视频中的效果，前景的圆是连接在一起的，有点 metaball 的感觉：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106180351.png)

所以，单个 Particle 绘制两层的思路并不对。

那么应该怎么实现？小菜做了一个动画来解释下：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/bubble.gif)

- 粒子内部只负责绘制圆形
- 在主程序用，用 particles 保存所有的粒子
- 遍历所有粒子，先将填充色填充为黑色背景色，这时候绘制出黑色的粒子层
- 再次遍历所有粒子，此次将填充色填充为白色前景色，绘制出白色的粒子层

```java
  // 第一次循环遍历，用来绘制粒子的底层边框色
  // display 用来绘制背景圆
  // update用来更新粒子的速度和位置
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    fill(BORDER_COLOR);
    p.display();
    p.update();
  }
  // 第二次循环遍历，用来绘制粒子的前景色
  // display2 用来绘制前景圆
  // update用来更新粒子的速度和位置
  for (int j = 0; j < particles.size(); j++) {
    Particle p = particles.get(j);
    fill(FG_COLOR);
    p.display2();
    p.update();
  }
```

## 气泡粒子的缩放

作者为了丰富粒子的效果，设计了两种类型，使用了两种绘制模式，`display()`和`display2()`：

- type0：背景黑色圆大小固定，前景白色圆来回缩放（使用 updateBorder ）
- type1：背景黑色圆来回缩放，前景白色圆来回缩放

读者朋友们可以回到文章开头，再仔细观察下视频中的效果，可以体会体会，一些生动往往体现在细节中。

```java
// 绘制背景边框圆
  // type 0：背景边框圆大小固定
  // type 1：背景边框圆直径来回增加/缩小
  void display() {
    if (type == 0) {
      ellipse(location.x, location.y, radius, radius);
    } else {
      updateBorder();
      ellipse(location.x, location.y, radius + border, radius + border);
    }
  }

  // 绘制前景圆
  // type 0: 前景圆直径来回缩小/增加
  // type 1: 前景圆大小固定
  void display2() {
    if (type == 0) {
      updateBorder();
      ellipse(location.x, location.y, radius - border, radius - border);
    } else {
      ellipse(location.x, location.y, radius, radius);
    }
  }

  void updateBorder() {
    // 如果边框小于最小值或者大于最大值，则将边框增量幅度 * -1， 用于将增量变为减量，或者减量变为增量
    if (border < MIN_BORDER || border > MAX_BORDER) {
      incBorder *= -1;
    }
    // 始终用 border = border + incBorder 来修改 border
    // border 的大小变会在 MIN_BORDER 和 MAX_BORDER 之间来回变换
    border += incBorder;
  }
```

## 气泡粒子的运动

“你怎么运动，也休想逃出我的掌心”

这里用的思路，在编程中很常见，就是**预见未来，改变现在**。举个简单的例子，经典的炸弹人游戏：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/20211106182916.png)

这个游戏陪伴了小菜的童年，至今想起来，还能想到那段快乐的时光，不禁嘴角上扬...

游戏中的地图的生成逻辑，对于炸弹人通常是这么做的。假设可通过的草地编号为0，不可爆破的砖块我们编号为1，可爆破的砖块编号为2，游戏通往下一关的关卡编号3，玩家的编号为4，坏蛋的编号为5，那么我们无论我们是通过关卡编辑器生成地图，还是我们硬核输入二维地图数据，比如：

```java
1 1 1 1 1 1 1 1 1 1 1 1 1 
1 2 2 2 2 3 5 2 0 0 0 0 1
1 0 0 0 0 2 2 2 2 2 0 0 1
1 2 2 2 2 0 0 4 0 0 0 0 1
1 2 1 1 2 2 1 2 2 1 0 2 1
1 2 1 1 2 2 1 0 2 1 0 2 1
1 2 0 1 2 2 1 0 2 1 0 2 1
1 2 0 0 2 2 1 0 2 1 5 2 1
1 1 1 1 1 1 1 1 1 1 1 1 1 
```

在游戏开始的时候载入地图数据，然后不同的编号用不同的图形表示。

而玩家操作的主角通过手柄的上下左右进行方向移动，那么在游戏逻辑中通常会这么写：

```java
if (按了方向键上) {
  1. 要计算在玩家的上方的二维坐标位置
  2. 如果该位置不可通过比如为砖块类型，则return，啥也不做
  3. 否则该位置则可以通过，玩家的位置 y -= speed;
}  
```

所以思路就是：

- 预见未来：按照我的操作，或者我的速度，在下一次帧计算中，我可以到达那个位置吗？
- 改变现在：如果可以，我就过去，如果不可以，我就不动，或者反向运动等。

同样的编程思维可以用在这里，气泡的运动时时刻刻都在问，按照我现在的速度，下一帧我还在字体像素的范围中吗？如果不在就换个方向，如果在，我就继续前进。

> 备注：代码中的 list 保存了所有像素位置的颜色归一化的值，字体像素位置存的是0，非字体像素位置都是1，list[location]为1，表示非字体的像素。下面代码是颜色的归一化操作，在文章开头页也提到过。

```java
loadPixels(); // 加载像素数据
for (int y = 0; y <= height - 1; y++) {
  for (int x = 0; x <= width - 1; x++) {
    color pb = pixels[y * width + x]; // 通过（y * width + x）得到坐标（x，y）在 pixels 数组中的索引位置，获取坐标（x，y）的像素的颜色

    // 颜色的归一化操作！！！
    // 画布背景色为 BG_COLOR，文字颜色是黑色，此时像素颜色的红色通道值小于5，只能是文字的黑色
    // 也就是通过 red(pb) < 5 来简单快速的判断出文字所在的像素，将这些像素在list数组中的位置的数值都标记成0-黑色
    if (red(pb) < 5) {
      list[y * width + x] = 0;
    } else {  // 背景色，都标记成1
      list[y * width + x] = 1;
    }
  }
}
updatePixels(); // 更新像素
```

休想逃出字体的手掌心！

```java
// 速度和位置的更新
  void update() {
    location.add(velocity);
    // 抖动效果的终极秘诀：始终让粒子本身在文字黑色像素抖动
    // 按照目前的速度，下一个帧循环中，当前像素的左右像素是非黑色（非文字像素）时，则将x轴速度乘以-1进行反向
    int nextLocX1 = int(location.y) * width + int(location.x + velocity.x);
    int nextLocX2 = int(location.y) * width + int(location.x - velocity.x);
    if ((list[nextLocX1] == 1)   ||   (list[nextLocX2] == 1)) {
      velocity.x *= -1;
    }
    // 按照目前的速度，下一个帧循环中，当前像素的上下像素是非黑色（非文字像素）时，则将y轴速度乘以-1进行反向
    int nextLocY1 = int(location.y + velocity.y) * width + int(location.x);
    int nextLocY2 = int(location.y - velocity.y) * width + int(location.x);
    if ((list[nextLocY1] == 1) || (list[nextLocY2] == 1)) {
      velocity.y *= -1;
    }
  }
```

## 总结

源码的分析是一件很快乐的事情，我们不是为了单纯学而学，重要的是掌握这种类型作品的一些创作思路。小菜始终相信，生成艺术伴随着一些随机和意外的惊喜，但这一切的背后，都蕴藏着某些既定的模式，可能是某些精妙的数学公式，也有可能是我们不了解的某种规则，而我们处理这些模式的方式，就是多见、多想、多实践。

完整源码见 https://github.com/xiaocai-laoniao/OpenProcessingSourceCodeAnalysis。



---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在2021/11/13号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/06/4511636196397_.pic.jpg)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)

