# 老师，我再也不怕Processing动图啦 - 深度解析Processing图片序列帧动画

老师：好，本周作业大家写个小游戏，题目不限。

同学甲：我来个“飞机大战”。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/11/20211111132615.png)

同学乙：我来个“见缝插针”。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/11/20211111132842.png)

同学丙：我来个"Flappy Bird"。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/11/20211111133006.png)

同学丁：要不要这么卷？我...有一个超级棒的idea，但是需要动图，不知道咋办。

小菜来啦！一文带你彻底了解 Processing 中常见的几种处理动图方式。看完直呼，老师，我再也不怕 Processing 动图啦！

## 动图的几种类型

说到动图，我们常常在游戏中见到。有时候我们也需要在 Processing 中使用，一般有哪些方式呢？

第一种，直接加载 GIF 动图显示；

第二种，加载序列图片

第三种，加载精灵图

下面我们就三种方式逐个作个说明。

## 直接加载 GIF

在 Processing 中，`loadImage`函数支持 4 种类型的图片：`gif`,`png`,`jpg`,`tga`。

但经过小菜测试，如果`gif`本身是动图，直接`loadImage`展现出来是不能动的。

要想让加载的`gif`动起来，需要对加载的图形数据进行解码，分析出`gif`中包含的多张图片数据。幸运的是，有开源库已经帮助我们做了这件事情。

gif-animation: http://extrapixel.github.io/gif-animation/



### 效果展示

小菜在百度上随便找了一个gif动画，按照 gif-animation 的官方例子，做了一个demo。

源码地址：[Processing速写Day040](https://github.com/xiaocai-laoniao/Processing100DaysSketch/tree/main/Day_040)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/playgif.gif)

**Demo描述**

- 3个gif动画，左中右
- 左gif为循环gif，一直不停的循环播放
- 中gif只播放一次，可以通过鼠标点击，播放一次
- 右gif的播放收到鼠标 x 位置影响，将 x 的位置映射到 gif 中图片的播放位置
- 通过`play()`和`pause()`来控制 gif 的播放和暂停，在这个 demo 中我们可以通过敲击键盘的空格键来切换播放和暂停状态，详细可以看`keyPressed()`函数的实现

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/gif-content.gif)

我们知道一个 gif 动图内部通常是有多张图片组成，比如我们这个 demo 中的比心动图，里面就包含了 13 张图片，用程序的索引表达就是 0 - 12，从 0 开始数到 12，一共 13 个数。

**关键程序解释**

- `PImage[] animation = Gif.getPImages(this, "demo.gif");`获取到 gif 中的所有图片，保存到一个数组中。
- `int animationIndex = (int)(map(mouseX, 0, width, 0, animation.length - 1));` 这个例子中使用鼠标的 x 位置来 map 映射到 gif 内部图片数组的索引，从而控制 gif 播放的进度
- `image(animation[animationIndex], width - 10 - gifWidth, height / 2 - gifHeight / 2);`将 gif 中对应编号索引的图片显示在特定位置上，随着编号的不断变化，呈现 gif 播放的效果



```java
import gifAnimation.*;

PImage[] animation;
Gif loopingGif;
Gif nonLoopingGif;

boolean pause = false;

public void setup() {
  size(800, 300);
  frameRate(60);
  
  println("gifAnimation " + Gif.version());
  
  // 一个循环播放的gif动画
  loopingGif = new Gif(this, "demo.gif");
  loopingGif.loop();
  
  // 一个不循环播放的gif动画，只播放一次，通过ignoreRepeat控制
  nonLoopingGif = new Gif(this, "demo.gif");
  nonLoopingGif.play();
  nonLoopingGif.ignoreRepeat();
  
  // 获取到gif中的所有图片，保存到PImage[]数组中
  animation = Gif.getPImages(this, "demo.gif");
}

void draw() {
  background(255);
  
  // 绘制循环gif
  image(loopingGif, 10, height / 2 - loopingGif.height / 2);
  // 绘制不循环gif，mousePressed函数中点击鼠标可以再次播放一次
  image(nonLoopingGif, width/2 - nonLoopingGif.width/2, height / 2 - nonLoopingGif.height / 2);
  
  // 这个例子中使用鼠标的x位置来map映射到gif内部图片数组的播放进度
  int animationIndex = (int)(map(mouseX, 0, width, 0, animation.length - 1));
  float gifWidth = animation[0].width;
  float gifHeight = animation[0].height;
  image(animation[animationIndex], width - 10 - gifWidth, height / 2 - gifHeight / 2);
}

void mousePressed() {
  nonLoopingGif.play();
}

void keyPressed() {
  // 敲击空格键
  if (key == ' ') {
    // 如果动画已经暂停，则播放，否则暂停
    if (pause) {
      nonLoopingGif.play();
      loopingGif.play();
      pause = false;
    } 
    else {
      nonLoopingGif.pause();
      loopingGif.pause();
      pause = true;
    }
  }
}
```





### 如何安装

我们可以通过 Processing 软件安装三方库的方式（速写本-引用库文件-添加库文件）

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/11/20211111233325.png)

小菜使用的是 Processing4 beta2，安装结束运行示例文件，运行报错，看报错信息，应该是库不兼容。

```java
gifAnimation 2.3
NoSuchMethodError: 'java.io.InputStream processing.core.PApplet.openStream(java.lang.String)'
```

默认安装的是 2.3 版本（图中 3.0 版本是小菜后面在github上下载 3.0 包解决后显示的）

经过小菜尝试，该库的 3.0 分支中的 gifAnimation.zip 是可以使用的。

gifAnimation 3.0 地址：https://github.com/extrapixel/gif-animation/blob/3.0/distribution/gifAnimation.zip

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/11/20211111233504.png)



## 图片序列帧

什么是图片序列帧？

我们常说的图片序列帧指的是多张图片，他们的文件名有编号的，有数字递增的规律，方便程序来处理，比如行走动画`walk01.png`,`walk02.png`,`walk03.png`,`walk04.png`,...,`walk12.png`。

在 Processing 中使用图片序列帧展示一个动图也比较简单，关键是`image(img, x, y)`函数。在 Processing 官网中也给出了一个例子，地址为：[animatedsprite](https://processing.org/examples/animatedsprite.html)。

例子描述：

- 两组图片序列帧
- PT_Shifty_0000 - PT_Shifty_0037，PT_Shifty_作为图片名前缀的图片序列帧一共38张图
- PT_Teddy_0000 - PT_Teddy_0059，PT_Teddy_作为图片名前缀的图片序列帧一共60张图
- 鼠标点击和不点击，分别播放上面两组不同的动画，背景色也有变化区分

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/animatedsprite2.gif)

### 加载序列图片

我们重点看`Animation`类的实现。

```java
Animation animation1, animation2;

float xpos;
float ypos;
float drag = 30.0;

void setup() {
  size(640, 360);
  background(255, 204, 0);
  frameRate(24);
  
  // PT_Shifty_0000 - PT_Shifty_0037，PT_Shifty_作为图片名前缀的图片序列帧一共38张图
  animation1 = new Animation("PT_Shifty_", 38);
  // PT_Teddy_0000 - PT_Teddy_0059，PT_Teddy_作为图片名前缀的图片序列帧一共60张图
  animation2 = new Animation("PT_Teddy_", 60);
  
  ypos = height * 0.25;
}

void draw() { 
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;

  // Display the sprite at the position xpos, ypos
  if (mousePressed) {
    background(153, 153, 0);
    animation1.display(xpos-animation1.getWidth()/2, ypos);
  } else {
    background(255, 204, 0);
    animation2.display(xpos-animation1.getWidth()/2, ypos);
  }
}
```

```java
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    // 根据图片数量，遍历加载图片，保存到PImage「」数组中
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  // frame每帧加1，通过对 imageCount 取余来实现循环
  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
```

- Animation 初始化需要传入图片序列帧文件名的前缀部分和序列帧的图片个数
- 图片序列帧文件名的前缀也就是数字前面的部分，如 PT_Shifty_0000 - PT_Shifty_0037，图片名称前缀是"PT_Shifty_"
- `String filename = imagePrefix + nf(i, 4) + ".gif";`负责组装图片文件的名称，i 是图片的编号，`nf(i, 4)`会生成一个字符串，表示数字用 4 位数表达，比如 1， 不足 4 位，会在前面补 0，形成 4 位数 0001
- `frame = (frame+1) % imageCount`：frame每帧加1，通过对 imageCount 取余来实现循环
- `image(images[frame], xpos, ypos);`将图片显示在对应位置上



### 控制 gif 速度

上面的实现有些简陋，比如没有实现 gif 动画的暂停，是否循环，以及播放速度等。

如何控制动画的速度呢？

第一个直觉是控制 frameRate，也就是帧率，提高帧率或者降低帧率都会影响动图的速度，但是不推荐这样做，因为这样也会影响其他部分动画的速度，比如你做了一个圆，它的大小位置变化速率都会受到影响。

还有没有其他方式呢？

我们可以在`Animation`中添加`speed`的属性，以及一个`frameSum`的属性用来保存累加的量，通过`frame = int((frameSum + speed) % imageCount);`就完美实现了速度的控制。当然这只是一个例子，为了更灵活，`speed`属性最好放在构造函数中，由外部传入。

源码地址：[Processing速写Day040](https://github.com/xiaocai-laoniao/Processing100DaysSketch/tree/main/Day_041)

```java
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  float frameSum = 0;
  float speed = 0.6;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    // 根据图片数量，遍历加载图片，保存到PImage「」数组中
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".png";
      images[i] = loadImage(filename);
    }
  }

  // frame每帧加speed，通过对 imageCount 取余来实现循环
  void display(float xpos, float ypos) {
    frameSum += speed;
    frame = int((frameSum + speed) % imageCount);
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
```



![speed = 0.1](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/gif_0.1.gif)

![speed = 0.6](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/gif_0.6.gif)

![speed = 1](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/gif_1.gif)

![speed = 3](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/gif_3.gif)

## 精灵图sprite sheet

什么是精灵图？

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/20211113214027.png)

有人叫雪碧图，知道是这个东西就行。

精灵图就是把很多的小图片合并到一张较大的图片里，这样在加载大量图片时，就不用加载过多的小图片，只需要加载出来将小图片合并起来的那一张大图片也就是精灵图即可，这样在一定程度上减少了页面的加载速度，如果图片是网络下载的，也一定程度上缓解了服务器的压力。所以精灵图技术被大量应用在了游戏领域，以及web领域，比如使用 css 精灵图像等。

通常在使用精灵图的时候，还有一个配置文件，通常是 json 或者 xml 格式，里面描述了精灵图中的子图的名称，矩形坐标和大小。

**所以使用精灵图的思路就是读入精灵图和精灵图的配置，然后按照配置中描述的子图片的坐标位置和大小进行区域图片读取操作，用到的就是`get(x, y, width, height)`将图片特定矩形范围内的像素保存到`PImage`图片中，然后使用类似图片序列帧的处理方式来做动图效果。**

小菜之前做游戏开发的时候，使用的是[TexturePacker](https://www.codeandweb.com/texturepacker)这款软件。这款软件收费，也可以给作者发邮件申请一个免费的，当时小菜申请了一个，貌似能用 1 年，现在早已经过期了。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/20211113215500.png)

今天我们不用这个软件，作者提供了一个免费使用的方式：[free-sprite-sheet-packer](https://www.codeandweb.com/free-sprite-sheet-packer)。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/20211113231154.png)

我们可以把自己的序列帧通过图片中的`Add sprites`的方式添加进去，这里小菜就用默认的图片，直接右上角下载精灵图和配置文件(png和json文件)。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/20211113231449.png)

小菜用 Processing 处理的最后效果如下：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/spritesheet.gif)

源码地址：[Processing速写Day040](https://github.com/xiaocai-laoniao/Processing100DaysSketch/tree/main/Day_042)

我们根据配置文件的内容格式，编写我们的动画类：

```java
import java.util.*;

PImage spritesheet;
// JSONObject https://processing.org/reference/loadJSONObject_.html
JSONObject spritesheetConfig;

Sprite demoSprite;

float posX;

void setup() {
  size(400, 200);
  
  // 加载精灵图
  spritesheet = loadImage("spritesheet.png");
  // 加载精灵图配置文件，因为配置是json格式，通过 loadJSONObject 保存到 JSONObject 中
  spritesheetConfig = loadJSONObject("spritesheet.json");
  
  // 精灵图初始化，传入精灵图和配置以及播放速度
  demoSprite = new Sprite(spritesheet, spritesheetConfig, 0.2); 
}

void draw() {
  background(255);
  
  posX = (posX + 1) % width;
  // 精灵图在特定位置播放
  demoSprite.display(posX, 0);
}
```

```java
class Sprite {
  PImage spritesheet;
  JSONObject config;
  ArrayList<PImage> imageArr;
  int frame;
  float frameTotal;
  float animationSpeed;

  Sprite(PImage spritesheet, JSONObject config, float animationSpeed) {
    this.spritesheet = spritesheet;
    this.config = config;
    this.animationSpeed = animationSpeed;
    this.imageArr = new ArrayList();

    // 根据json配置将精灵图的子图通过 get(x, y, width, height) 保存到图片数组中
    JSONObject frames = this.config.getJSONObject("frames");
    Set framesSet = frames.keys();
    ArrayList<String> imageNameArr = new ArrayList(framesSet);
    imageNameArr.sort(Comparator.naturalOrder());
    for (int i = 0; i < imageNameArr.size(); i++) {
      String imageName = imageNameArr.get(i);
      JSONObject frameInfo = frames.getJSONObject(imageName).getJSONObject("frame");
      int imageX = int(frameInfo.getFloat("x"));
      int imageY = int(frameInfo.getFloat("y"));
      int imageWidth = int(frameInfo.getFloat("w"));
      int imageHeight = int(frameInfo.getFloat("h"));
      
      PImage img = this.spritesheet.get(imageX, imageY, imageWidth, imageHeight);
      this.imageArr.add(img);
    }
 
  }

  void display(float x, float y) {
    this.frameTotal += this.animationSpeed;
    
    this.frame = int(this.frameTotal % this.imageArr.size());
    image(this.imageArr.get(this.frame), x, y);
  }
}

```




## 总结

- gif-animation和图片序列帧的方式稍微简单，通常情况下推荐使用
- 使用 Processing 做游戏的时候，推荐精灵图的方式



---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在 2021/11/20 号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/13/20211113232303.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)
