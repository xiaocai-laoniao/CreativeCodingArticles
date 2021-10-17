# 生成艺术之缓动的奥秘-小白也能看的懂系列

## 前言

我们来接着上篇文章 [https://mp.weixin.qq.com/s/iuTBu52Hmkimrehfo8tcng](https://mp.weixin.qq.com/s/iuTBu52Hmkimrehfo8tcng)，实现递归方块动画效果，用到了缓动的知识。提到缓动，不得不提，真的是应用太广了，我们几乎可以在任何设计到动画编辑的软件上，看到缓动曲线的功能，如 Animate、AfterEffect、Godot、Unity等等都具备动画缓动效果处理的能力。



在开始涉及缓动之前，我们先将上篇文章递归方格子绘制切换到面向对象的方式。



> 小菜温馨提醒：文章比较长，且有一定的代码量需要理解，如果没有时间静下心来阅读，可以先收藏/关注下，安静时阅读最佳。

## 面向对象的递归绘制

我们将盒子封装成一个类，叫`SpringBox`，一个有弹性的方块盒子，为啥有弹性，这个就和设定的缓动相关参数有点关系了，一会说缓动的时候会说到。我们来看下使用面向对象编程的方式如何绘制。

```js
let box;
function setup() {
  createCanvas(windowHeight, windowHeight);
  background(100);
  box = new SpringBox(0, 0, width, height, 0);
}

function draw() {
  background(100);

  // 弹性方块绘制
  box.draw();
}

const MAX_DIV = 6;

class SpringBox {
  constructor(x, y, w, h, dc) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.targetDivRatio = 0.5;
    this.divRatio = 0.5;
    this.divCount = dc;
    this.children = [];

    if (dc < MAX_DIV) {
      if (dc % 2 == 0) {
        this.children[0] = new SpringBox(x, y, w * this.divRatio, h, dc + 1);
        this.children[1] = new SpringBox(x + w * this.divRatio, y, w * (1 - this.divRatio), h, dc + 1);
      } else {
        this.children[0] = new SpringBox(x, y, w, h * this.divRatio, dc + 1);
        this.children[1] = new SpringBox(x, y + h * this.divRatio, w, h * (1 - this.divRatio), dc + 1);
      }
    }
  }
  
  // 实际画面绘制部分
  draw() {
    if (this.children.length == 0) {
      let sw = 10;
      noStroke();
      fill(0);
      rect(this.x, this.y, this.w, this.h);
      fill(this.col);
      rect(
        this.x + sw / 2,
        this.y + sw / 2,
        this.w - sw,
        this.h - sw,
        0
      );
    } else {
      for (const c of this.children) c.draw();
    }
  }
  
}
```



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/box2.jpg)

原理解释：

1）每个 SpringBox 内部都有个`children`属性，用来存储递归绘制的子 box

2）递归的终止条件是什么？这里并没有控制方块的长或者宽小于某个阈值的方式，而是通过递归的深度来控制递归的结束，也就是`MAX_DIV`变量表示的含义。注意到 `SpringBox`的构造函数最后一个参数便是递归的次数（dc），或者深度，每次递归构造`SpringBox`的时候，深度都会加1

3）根据递归的次数，如果`dc % 2 == 0`，也就是递归的次数是偶数次，那么则竖向切一刀，将方块左右分割，默认比例 ratio 是 0.5，那么这两个左右矩形方块的绘制坐标和长寛如下

```js
this.children[0] = new SpringBox(x, y, w * this.divRatio, h, dc + 1);
this.children[1] = new SpringBox(x + w * this.divRatio, y, w * (1 - this.divRatio), h, dc + 1);
```

如果`dc % 2 != 0`，也就是递归的次数是奇数次，那么则横向切一刀，将方块上下分割，这两个上下矩形方块的绘制坐标和长寛如下

```js
this.children[0] = new SpringBox(x, y, w, h * this.divRatio, dc + 1);
this.children[1] = new SpringBox(x, y + h * this.divRatio, w, h * (1 - this.divRatio), dc + 1);
```

4）SpringBox 的`draw`函数：如果`children`数组内部有 box，那么要递归下去 draw，直到达到了终止条件，也就是递归到了尽头，那么此时`children`数组的元素个数应该是空的，此时应该直接绘制（一个黑色矩形背景，加一个小一点的矩形，填充自身的颜色），



## 如何动起来

### 核心：目标比例 + 缓动

我们在`SpringBox`类初始化中，加入变量`targetDivRatio`，表明方块盒子横向或者纵向切分的目标比例，那么下一个目标就是让`divRatio`也就是当前的切分比例，朝着`targetDivRatio`靠近就行。

```js
...
function draw() {
  background(100);

  // 弹性方块更新
  box.update();
  // 弹性方块绘制
  box.draw();
}

class SpringBox {
 	constructor(x, y, w, h, dc) {
    ...
  }
    
  update() {
    this.updateDiv();
    this.updateTL(this.x, this.y, this.w, this.h);
  }
    
  // 递归更新 targetDivRatio
  updateDiv() {
    this.targetDivRatio = random(0.15, 0.85);
    
    // 缓动的算法，让divRatio按照缓动方式逼近targetDivRatio
    let f = this.spK * (this.targetDivRatio - this.divRatio);
    let accel = f / this.spMass;
    this.spVel = this.spDamp * (this.spVel + accel);
    this.divRatio += this.spVel;
    
    for (const c of this.children) c.updateDiv();
  }
    
  // 递归更新坐标和尺寸大小
  updateTL() {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    if (this.children.length > 0) {
      if (this.divCount % 2 == 0) {
        this.children[0].updateTL(x, y, w * this.divRatio, h);
        this.children[1].updateTL(
          x + w * this.divRatio,
          y,
          w * (1 - this.divRatio),
          h
        );
      } else {
        this.children[0].updateTL(x, y, w, h * this.divRatio);
        this.children[1].updateTL(
          x,
          y + h * this.divRatio,
          w,
          h * (1 - this.divRatio)
        );
      }
    }
  }
    
  draw() {
    ... 
  }
}
```



## 数值逼近

有两个数，一个是目标数 target, 一个是当前数 current，那么都有哪些方式让 current 这个数值不断逼近 target 数。

我们就拿位置距离

【插入视频号】

1）第一种方式很常见，定义一个速度，在每帧绘制的时候，位置+速度得到新的位置

2）第二种方式也是一个很常见的缓动模式，current += (target - current) * k（0 < k < 1)，由快到慢的一个缓出效果，因为刚开始 target 和 current 相差很大，current 的增量也大，随着不断逼近 target，增量越来越小，可参见视频号中第2种方式的横坐标的打印

3）也是一个特别的公式，也是我们在最终效果中使用到的公式。质量和弹性等参数是算法中重要的因子，会直接影响数值的缓动效果

```js
current -> target 
1）系数k
2）质量mass
3）弹性damp
4）速度vel

公式：
f = k * (target - current)
a = f / mass  // 加速度
vel = damp * (vel + a)
current += vel
```



那么除了这些，还有哪些方式呢？

## 缓动的类型

现实中，物体在移动时往往会加速或减速。我们的大脑习惯于期待这种运动，这种缓动会让动画变得更加有活力，而不是单纯的线性 linear 运动。缓动动画有下面几种方式：

### 线性动画

没有任何缓动的动画称为**线性**动画。线性变换的图形看起来像这样:

![线性动画](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/20211017154615.png)

随着时间推移，其值以等量增加。采用线性运动时，动画内容往往显得很僵硬，不自然，让用户觉得不协调。



### 缓入动画

缓入动画开头慢结尾快，与缓出动画正好相反。

这种动画像沉重的石头掉落一样，开始时很慢，然后快速地重重撞击地面，突然沉寂下来。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/20211017154826.png)







### 缓出动画

缓出使动画在开头处比线性动画更快，还会在结尾处减速。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/20211017180935.png)

### 缓入缓出动画

缓入并缓出与汽车加速和减速相似，使用得当时，可以实现比单纯缓出更生动的效果。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/20211017154807.png)



## 缓动的算法

我们先对不同的算法有个直观的认识：

【插入视频号】

| 缓动算法          | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| quadratic（quad） | 二次方的缓动，f(t) = t^2；其中 f(x) 表示动画进度，t 表示时间，以下相同 |
| cubic             | 三次方的缓动，f(t) = t^3；                                   |
| Quartic           | 四次方的缓动，f(t) = t^4；                                   |
| Quintic           | 五次方的缓动，f(t) = t^5；                                   |
| Sinusoidal        | 正弦曲线的缓动，f(t) = sin(t)；                              |
| Exponential       | 指数曲线的缓动，f(t) = 2^t；                                 |
| Circular          | 圆形曲线的缓动，f(t) = sqrt(1 - t^2)；                       |
| Elasitc           | 指数衰减的正弦曲线缓动；                                     |
| Back              | 超过范围的三次方缓动，f(t) = (s + 1) * t^3 - 3 * t^2；       |
| Bounce            | 指数衰减的反弹缓动；                                         |

每种缓动算法效果都可以分为三个缓动方式

- easeIn：从0开始加速的缓动；

- easeOut：减速到0的缓动；

- easeInOut：前半段从0开始加速，后半段减速到0的缓动；



## Processing中的缓动

### Processing Java

在 Processing Java 模式下，有个 Ani 库专门用来处理缓动。

这里有小菜录制的一个预览视频，感兴趣的可以瞅瞅，我们可以看到在`Ani_Easing_Styles`这个例子中，常见的缓动算法 Ani 中都是有的。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/17/20211017172912.png)

### p5js

使用 p5js 的话，有开源库[https://github.com/Milchreis/p5.tween](https://github.com/Milchreis/p5.tween)可以使用。

```js
<script src="p5.min.js"></script>
<script src="https://unpkg.com/p5.tween@1.0.0/dist/p5.tween.min.js"></script>


// Adding motions to the TweenManager
p5.tween.manager
    // First add a new Tween to the manager for the effected object
    .addTween(object, 'tween1')
    // First motion: change the width (means object.width) to 12 in 100ms
    .addMotion('width', 12, 100, 'easeInOutQuint')
    // Second motion: Change x and y to mouse position in 500ms at the same time
    .addMotions([
                { key: 'x', target: mouseX },
                { key: 'y', target: mouseY }
            ], 500, 'easeInOutQuint')
    // Start the tween
    .start()
```

更多的用法可以查看官网[https://milchreis.github.io/p5.tween/](https://milchreis.github.io/p5.tween/)。



## 补充

这个例子最核心的思路就分析到这里，文字部分比较简单，小菜已经在开源仓库将详细的注释添加进去了。想了解完整信息的，可以戳这里：

[递归方块缓动变化完整源码和注释](https://github.com/xiaocai-laoniao/OpenProcessingSourceCodeAnalysis/blob/master/1286327/sketch.js)




---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/09/25/640.gif)

