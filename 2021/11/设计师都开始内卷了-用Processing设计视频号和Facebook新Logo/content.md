# 设计师都开始内卷了 - 用Processing设计视频号和Facebook新Logo

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/20211110074242.png)

今天小菜看到量子位的一篇文章 https://mp.weixin.qq.com/s/RwG8HaK02-Fa0t26UboD7w，了解到**李萨如曲线**这个东西。还挺有意思，Facebook 的 Meta Logo 和微信视频号的 Logo 真像，它们这不就上下颠倒了下嘛。

你说这年头设计师设计个Logo，还得了解李萨如曲线，已经“内卷”的不行了，哈哈哈。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/c81a168f0e80111.gif)



![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/20211108091747.png)

你瞧这公式：

`x=Asin(at+d), y=Bsin(bt), 0≤t≤2π`

x是一个正弦波，y也是正弦波，但两个正弦波他们的振幅A和B，周期，偏移等都不太相同，最终形成的曲线其实是**x轴和y轴两个方向的正弦振动合成的轨迹**。

我们用 GeoGeBra 这款软件模拟下

【插入视频号】

有点内味了。

参数 d 控制的是我们观察的角度，就像这样

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/640-1.gif)

读者朋友也可以从刚才的模拟中看到，改变参数 d，就会“旋转”曲线，在某个特定的值，就会出现微信视频号 Logo 和 Facebook Meta Logo 的样子。

## Processing模拟

【插入视频号】

模拟：按照公式`x=Asin(at+d), y=Bsin(bt), 0≤t≤2π`画点连线就行了。小菜将实现代码放在了 [https://openprocessing.org/sketch/1343088](https://openprocessing.org/sketch/1343088)。

```java
beginShape();
for (let t = 0; t < TWO_PI; t += 0.1) {
		let x = value_A * sin(value_a * t + value_d);
		let y = value_B * sin(value_b * t);
		curveVertex(x * value_scaleX, y * value_scaleY);
}
endShape();
```

## 补充

刚才我们提到在水平和垂直两个方向上正弦振动合成的轨迹，

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/20211110002050.png)

推荐大胡子的这个李萨如曲线绘制教学：

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/20211110003147.png)

【插入视频号】

openprocessing 源码地址：[https://openprocessing.org/sketch/1345045](https://openprocessing.org/sketch/1345045)

这个绘制思路大体是这样的：

- 绘制水平和垂直的圆，可以根据设定的画布大小除以圆直径得到行和列的个数
- 使用笛卡尔坐标系，在每个圆上绘制一个点，利用 angle 叠加，让点动起来
- 绘制水平线、垂直线，李萨如曲线就是水平垂直线的交点运动形成的轨迹
- 将将要绘制的李萨如曲线保存到一个二维数组中

```java
for (let j = 0; j < rows; j++) {
    curves[j] = [];
    for (let i = 0; i < cols; i++) {
      curves[j][i] = new Curve();
    }
  }
```

- 绘制李萨如曲线的点坐标由 x 坐标和 y 坐标组装而来，利用好双重循环设置好二维数组中曲线的点的坐标
- 遍历二维数组，调用曲线的绘制函数显示出曲线的路径（曲线路径的点不断增加，满一圈后重置）

怎么样，今天有收获吗？

---------

小菜与老鸟后期会不定期更新一些 Processing 绘制的代码思路分析，欢迎关注不迷路。

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在 2021/11/17 号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注Processing，小菜拉你入群。

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/11/08/20211110062346.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)
