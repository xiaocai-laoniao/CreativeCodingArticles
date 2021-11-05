# Processing之矢量SVG用法一览



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103092050.png)



本文是小菜的一篇关于在 Processing 中使用 SVG 的学习笔记，一起来跟着小菜来看看吧:)

## 读懂 SVG 文件

> SVG 是一种基于 XML 语法的图像格式，全称是可缩放矢量图（Scalable Vector Graphics）。其他图像格式都是基于像素处理的，SVG 则是属于对图像的形状描述，所以它本质上是文本文件，体积较小，且不管放大多少倍都不会失真。

SVG文件里面究竟是什么？用最简单粗暴的话来说，文件内容记录的不是像素信息，而是图形的元数据信息，比如

- 一个圆`circle`（圆心、半径）
- 一条线`line`（两个端点坐标）
- 一条折线`polyline`（折线点的坐标）
- 一个矩形`rect`（左上角端点坐标和矩形宽高）
- 一个椭圆`ellipse`（椭圆中心的横坐标和纵坐标、椭圆横向轴和纵向轴的半径）
- 一个多边形``polygon``（每个端点的坐标）
- 一个路径`path`（路径描述）
- 一个文本`text`（文本区块基线baseline起点的横坐标和纵坐标）
- 一个图片`image`（图片的路径来源）
- 一个动画`animate`（动画的初始值、结束值、循环模式等）

我们举一个路径的例子：

我们按照本文后面SVG导出的做法导出一个svg

```java
import processing.svg.*;

void setup() {
  size(300, 180, SVG, "path.svg");
}

void draw() {
  beginShape();
  vertex(18, 3);
  vertex(46, 3);
  vertex(46, 40);
  vertex(61, 40);
  vertex(32, 68);
  vertex(3, 40);
  vertex(18, 40);
  endShape(CLOSE);
  
  println("Finished.");
  exit();
}
```

然后找个记事本或者代码编辑器打开生成`path.svg`文件，可以看到核心的路径描述部分（小菜精简了一下，去掉了一些无关的如xml版本以及一些样式信息）



SVG路径的语法科普下：

- M：移动到（moveto）
- L：画直线到（lineto）
- Z：闭合路径

我们在这个例子中，使用 Processing 绘制了一个朝下的箭头，因为使用的是无窗口输出，我们就预览下生成的 SVG：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211104211437.png)

```xml
<svg width="300" height="180">
<path d="
  M 18,3
  L 46,3
  L 46,40
  L 61,40
  L 32,68
  L 3,40
  L 18,40
  Z
"></path>
</svg>
```

记录的是路径的原始信息，难怪人家放大多少倍都不失真呢！

更多更详细的例子推荐大家阅读阮一峰老师的文章，浅显易懂：[阮一峰：SVG 图像入门教程](https://www.ruanyifeng.com/blog/2018/08/svg.html)。

## 导入

来自[官方网站Load and Display a Shape Illustration](https://processing.org/examples/loaddisplaysvg.html)。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103092050.png)

loadShape() 命令用于将简单的 SVG 文件读入处理。此示例加载怪物机器人面部的 SVG 文件并将其显示在屏幕上。

```java
PShape bot;

void setup() {
  size(640, 360);
  bot = loadShape("bot1.svg");
} 

void draw(){
  background(102);
  // 将两个 bot 根据不同的坐标和大小，使用 shape 函数绘制出来
  shape(bot, 110, 90, 100, 100);    
  shape(bot, 280, 40);
}
```

## 操作SVG

### 1）修改SVG样式
本例子的形状加载了绘制的样式信息（例如颜色、笔画粗细）。PShape 的 disableStyle() 方法用来关闭此信息，stroke() 和 fill() 等函数更改 SVG 颜色。使用 enableStyle() 方法重新打开文件的原始样式。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103092216.png)

```java
PShape bot;

void setup() {
  size(640, 360);
  bot = loadShape("bot1.svg");
  noLoop();
} 

void draw() {
  background(102);
  
  // 绘制上图中的左边的机器人头像
  bot.disableStyle(); // 禁用 SVG 的样式
  fill(0, 102, 153);  // 填充 SVG 色彩
  stroke(255);  // 设置 SVG 线条颜色为白色
  shape(bot, 20, 25, 300, 300);

  // 绘制上图中的右边的机器人头像
  bot.enableStyle();
  shape(bot, 320, 25, 300, 300);
}
```

### 2）缩放 SVG

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103092724.png)

例子中使用`mouseX`映射到缩放系数zoom 上，区间范围为`0.1-4.5`，然后通过`scale(zoom)` 来实现 svg 的缩放。非常平滑，没有锯齿。

```java
PShape bot;

void setup() {
  size(640, 360);

  bot = loadShape("bot1.svg");
} 

void draw() {
  background(102);
  translate(width/2, height/2);
  float zoom = map(mouseX, 0, width, 0.1, 4.5);
  scale(zoom);
  shape(bot, -140, -140);
}
```

### 3）操作子节点

SVG 文件可以由许多单独的形状组成。这些形状中的每一个（称为“子”）都有自己的名称，可用于从“父”文件中提取它。此示例加载美国地图并通过从两个州提取数据来创建两个新的 PShape 对象。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103093621.png)

```java
PShape usa;
PShape michigan;
PShape ohio;

void setup() {
  size(640, 360);  
  usa = loadShape("usa-wikipedia.svg");
  michigan = usa.getChild("MI");
  ohio = usa.getChild("OH");
}

void draw() {
  background(255);
  
  // 绘制出整个地图
  shape(usa, -600, -180);
  
  // 禁用 michigan 该子形状的样式
  michigan.disableStyle();
	// 自定义填充色
  fill(0, 51, 102);
  noStroke();
  shape(michigan, -600, -180);
  
  // 禁用 ohio 该子形状的样式
  ohio.disableStyle();
	// 自定义填充色
  fill(153, 0, 0);
  noStroke();
  shape(ohio, -600, -180);
}
```



### 4）操作 SVG 顶点信息

如何迭代形状的顶点。加载 SVG 时，getVertexCount() 通常会返回 0，因为所有顶点都在子形状中。这时候我们可以遍历子形状，然后再遍历他们的顶点。可以看下面代码的详细注释。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211103093204.png)

```java
PShape uk;

void setup() {
  size(640, 360);
  uk = loadShape("uk.svg");
}

void draw() {
  background(51);
  translate(width/2 - uk.width/2, height/2- uk.height/2);
  
  // 获取到所有子形状的个数
  int children = uk.getChildCount();
  // 遍历子形状
  for (int i = 0; i < children; i++) {
    // 得到子形状
    PShape child = uk.getChild(i);
    // 子形状继续获取顶点个数
    int total = child.getVertexCount();
    
    // 遍历所有顶点，然后获取顶点的位置，使用 point 绘制出来
    for (int j = 0; j < total; j++) {
      PVector v = child.getVertex(j);
      stroke((frameCount + (i+1)*j) % 255);
      point(v.x, v.y);
    }
  }
}
```



## SVG 

## 导出

SVG 库使得直接从 Processing 编写 SVG 文件成为可能。这些矢量图形文件可以缩放到任何大小并以非常高的分辨率输出。 

按照官网的例子，我们有下面5种常见的输出方式：

- 无窗口式输出
- 窗口式输出
- 窗口式动画单帧输出
- 窗口式3D图形输出
- PGraphics式输出

### 1）无窗口式输出

此示例将单个帧绘制到 SVG 文件并退出。需要注意的是，这样操作并不会打开任何显示窗口；当我们尝试创建远大于屏幕尺寸的大量 SVG 图像时，这种方式会很有用。

```java
import processing.svg.*;

void setup() {
  size(400, 400, SVG, "filename.svg");
}

void draw() {
  // Draw something good here
  line(0, 0, width/2, height);

  // Exit the program
  println("Finished.");
  exit();
}
```



### 2）窗口式输出

通过`beginRecord()`和`endRecord()`函数在屏幕上绘制的时候保存 SVG。

```java
import processing.svg.*;

void setup() {
  size(400, 400);
  noLoop();
  beginRecord(SVG, "filename.svg");
}

void draw() {
  // Draw something good here
  line(0, 0, width/2, height);

  endRecord();
}
```



### 3）窗口式动画单帧输出

```java
import processing.svg.*;

boolean record;

void setup() {
  size(400, 400);
}

void draw() {
  if (record) {
    // 每次绘制，保存svg 序列图，文件名如 frame-0001.svg 这样
    beginRecord(SVG, "frame-####.svg");
  }

  background(255);
  line(mouseX, mouseY, width/2, height/2);

  // 只绘制1次就停止录制
  if (record) {
    endRecord();
    record = false;
  }
}

// 点击鼠标开始录制
void mousePressed() {
  record = true;
}
```



### 4）窗口式3D图形输出

要创建 3D 矢量图形，需要使用`beginRaw()`和`endRaw()`命令。这些命令将在形状数据呈现到屏幕之前抓取形状数据。在这个阶段，整个场景只不过是一长串线条和三角形，这时使用`sphere()`方法创建的形状将由数百个三角形组成，而不是单个对象。

```java
import processing.svg.*;

boolean record;

void setup() {
  size(500, 500, P3D);
}

void draw() {
  if (record) {
    beginRaw(SVG, "output.svg");
  }

  background(204);
  translate(width/2, height/2, -200);
  rotateZ(0.2);
  rotateY(mouseX/500.0);
  box(200);

  if (record) {
    endRaw();
    record = false;
  }
}

void keyPressed() {
  if (key == 'r') {
    record = true;
  }
}
```



### 5）PGraphics式输出

我们也可以使用`createGraphics()`函数输出编写 SVG 文件，需要注意的是必须在`PGraphics` SVG 对象上调用`dispose()`。

```java
import processing.svg.*;

PGraphics svg = createGraphics(300, 300, SVG, "output.svg");
svg.beginDraw();
svg.background(128, 0, 0);
svg.line(50, 50, 250, 250);
svg.dispose();
svg.endDraw();
```



## 更多阅读

- [https://bjango.com/articles/processingsvg/](https://bjango.com/articles/processingsvg/)
- [https://processing.org/reference/libraries/svg/index.html](https://processing.org/reference/libraries/svg/index.html)





---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在2021/11/11号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/03/20211104211927.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)

