# Processing手部跟踪

有天小菜在看视频号，很大声牛兄的一个视频系统给我推送了过来

【插入很大声视频号-周刊21】

类似还有最近的这个

【插入很大声视频号-明和电机-北京展】

比较好奇，手部的跟踪识别是怎么做到的。

起初我以为牛兄是用 Processing Java 做的，我记得没有好用的手部识别库，而一个 OpenCV 识别脸部的还各种报错。是用 Kinect 做的吗？经过和牛兄的沟通，原来是使用 p5js 实现的，使用的是一个叫做`Handtrack.js`的一个 js 库。

于是花了点时间研究了下，总结一下，做个备忘和信息分享。

借助`Handtrack.js`库，可以不需要再依赖额外的传感器或者其他硬件，只需要浏览器和摄像头就能实现手部动作的检测和追踪，确实方便不少。

## 初识HandTrack

- [HandTrack github 地址](https://github.com/victordibia/handtrack.js/)
- [官方网站](https://victordibia.com/handtrack.js/)



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/24/20211024140515.png)



Handtrack 的背后依赖的是 TensorFlow，借助机器学习，能够对手部姿势和脸部进行检测和跟踪。**在使用的时候，浏览器其实会下载一个识别模型，这个模型就是机器学习的产物，输入数据，就能按照学习的结果，输出结果。输出结果的准确度，取决于机器学习的算法以及训练程度。**

目前支持的7种姿势：

- open-手部打开姿势
- closed-手部关闭姿势，如拳头等形态
- pinch-手指捏合姿势
- point-手指指向☝🏻姿势
- face-脸部
- pointtip
- pinchtip

后面两种 tip 类型小菜在测试的时候暂时没有测试出来。

【插入视频号内容】



## Handtrack如何在p5js中使用？

### 1) 引入 handtrack.js

我们在 html 中除下引入 p5.js、p5.sound.min.js（如果用到声音处理）等 p5 核心 js 文件后，引入

`<script src="https://cdn.jsdelivr.net/npm/handtrackjs@latest/dist/handtrack.min.js"></script>`。成熟好用的 js 库一般都会在`cdn.jsdelivr.net` cdn 上有存储地址。这里我们不考虑`npm install`的情况，如果读者有这方面的诉求，可以查看 github 上的 readme 获得更详细的说明。

```js
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.0/p5.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.0/addons/p5.sound.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/handtrackjs@latest/dist/handtrack.min.js"></script>
	<script src="sketch.js"></script>
	<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>   
	
</body>

</html>
```

### 2）声明模型的配置

```js
// 参考官方的例子配置
const modelSettings = {
	flipHorizontal: true, // 水平是否镜像反转，如摄像头数据
	maxNumBoxes: 10, // 最大检测的矩形盒子数量
	iouThreshold: 0.5,  // iou阈值
	scoreThreshold: 0.6 // 评分阈值
}
```

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/24/20211024193130.png)



### 3）下载模型开启检测

开启摄像头，成功后，handTrack 按照模型设置进行下载相应的模型，下载成功后，开始检测`runDetection()`。

```js
let canvas; // 画布
let model; // 模型
let capture; // 摄像头视频
function setup() {
	canvas = createCanvas(640, 480);

	capture = createCapture(VIDEO, function() {
		handTrack.load(modelSettings).then(lmodel => {
			model = lmodel;
			runDetection();
		});
	}); 
}
```



开启检测内部具体做了什么事情呢？

```js
let predictionArr;

function runDetection() {
 	// 模型开始对摄像头的 elt（dom 对象）中的数据进行检测
  // then 是 js 的 promise 的一种语法，这里简单理解一次检测结束后，获得了预测结果 predictions
	model.detect(capture.elt).then(predictions => {
		predictionArr = predictions;
		// model.renderPredictions(predictions, canvas, context, capture.elt); // 渲染检测值
		if (capture) {
      // 每一帧需要对摄像头数据进行检测
			requestAnimationFrame(runDetection);
		}
	});
}

```

这个检测会输入摄像头捕获的数据，然后给出预测结果**。

### 4）玩转预测结果

我们在第三步拿到了预测结果`predictionArr`，便可以愉快的玩耍了。

那么这里面究竟存放了什么数据？

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/24/image-20211024194349127.png)

数组中的单个元素的数据结构如下：

```js
{
    "bbox": [
        125.76276779174805,
        43.020243644714355,
        215.00505447387695,
        307.0961809158325
    ],
    "class": 5,
    "label": "face",
    "score": "0.76"
}
```

- label：识别预测的类型，包含上面列举的7种类型，face、open、closed、pinch、point 等
- score：打的分数，表示预测结果的好坏，分数越高，表明预测的准确度越高
- class：和 label 标签类型对应，可以忽略
- bbox：识别出的 label 它的像素位置和长宽范围，如识别出来的 label 为 face，bbox则为脸部的矩形范围，bbox[0]指的是矩形左上角 x 坐标，bbox[1]指的是矩形左上角 y 坐标，bbox[2]指的是矩形宽度，bbox[3]指的是矩形高度。

```js
function drawPredictions() {
  predictionArr.forEach((item, i) => {
    // console.log(item);
    let w = item.bbox[2];
    let h = item.bbox[3];
    let x = item.bbox[0];
    let y = item.bbox[1];
    let centerX = x + w / 2;
    let centerY = y + h / 2;
    let score = item.score;
    let label = item.label;

    stroke(0);
    strokeWeight(2);
    fill(0, 100);
    rect(x, y, w, h, 10, 10, 10, 10); // 我就画个半透明矩形
    noStroke();
    fill(255);
    text(score, x + 10, y + 10); // 我就画个分数
    fill(255, 255, 0);
    text(label, x + 10, y + 40); // 我就画个标签

    // 你想干啥就在这里干吧
    if (item.label == "face") {
    } else if (item.label == "open") {
    } else if (item.label == "closed") {
    } else if (item.label == "point") {
    } else if (item.label == "pinch") {
    }
  });
}
```
这个最后的效果如上面视频号展示。

有了这些数据，我想，创意就交给亲爱的读者们了！

## 一些应用例子

其实手势的应用很广泛，放在 processing 中，我们常常可以这么做：

1）将原来鼠标移动的控制改为手部移动的控制

2）当手和其他物体重叠时，可以**表示有意义的交互信号**，如物体碰撞，选择物体等

3）两只手的协调处理，比如两只手一起转动，连线的角度就会发生变化，可以用来控制物体的旋转角度等

### Skyfall

Wiki 上的一个例子，来自[codepen](https://codepen.io/victordibia/full/aGpRZV)，代码也是开源的，只不过不是用 p5js 的方式写的。

【插入视频号】



## 源码

代码小菜已经放到 https://github.com/xiaocai-laoniao/Processing100DaysSketch的 Day_032 练习中了，感兴趣的读者可以查看代码。或者直接查看 https://openprocessing.org/sketch/1322756。



---------
小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

如果有收获，能一键三连么？

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/09/25/640.gif)