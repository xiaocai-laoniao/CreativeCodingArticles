![img](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/key_cover.png)

此『键盘侠』非彼『键盘侠』也！

在 Processing 编程中，我们常常会遇到对键盘按键的一些处理。最近在群里，也看到一些朋友询问这方面的问题，本篇小菜介绍下 Processing 中关于键盘事件的常用处理方式。

要做，就做一名合格的『键盘侠』，稳妥处理Processing 中键盘的按键处理！哈哈~

![](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/20211211135939.png)

## 键盘事件

键盘是 Processing 中最常见的数据输入方式（常见的还有鼠标、文件以及其他硬件输入等）。

在 Processing 中，关于键盘处理，需要记住3变量3函数。

3变量：key、keyCode、keyPressed

3函数：keyPressed()、keyReleased()、keyTyped()

要想应对各种输入情况，我们需要对这3变量3函数有着充分的认识。

宫本武藏：排好队，一个一个来！

![img](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/key_keyCode.png)

小菜绘制了一张图，总结了下键盘事件的一些关键知识点。

- 键盘事件分成了三个事件类型，`keyPressed()` 、`keyReleased()` 、`keyTyped()`。分别表示按住键盘键，释放键盘键，以及一次完整的键盘敲击
- 有一个特殊的常量，`CODED` 值为 65535，是 2 的 16 次方减 1
- key：键盘敲击过程中的一个变量，使用 ASCII 码值表示，可以与代表 ASCII 码值的字符进行比较，如 `key == 'a'`。
- keyCode：key 处理不了的非 ASCII 码字符，使用 keyCode 来处理，但需要使用 `key == CODED` 来进行判断

## key

常见的键盘字符如小写的 a-z，大写的 A-Z，以及 0-9 这些，我们可以很方便的使用下面的例子来判断。特别要注意的是 ASCII 码字符表示的时候要用单引号，如 'a' 不是 "a"。

关于 ASCII 码，不太了解的读者朋友们，可以回头查看维基百科[ASCII](https://zh.wikipedia.org/wiki/ASCII)。

> ASCII只能显示 26 个基本拉丁字母、阿拉伯数字和英式标点符号。每个符号都对应着一个十进制数值。

关于 ASCII 码，可以百度搜索 "ASCII 对照表"。

![](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/20211211140244.png)

```Java
void keyPressed() {
  if (key == 'a') {
    println("敲击了a");
  } else if (key == 's') {
    println("敲击了 s，进行图像保存");
    save("myImage.png");
  } else if (key == '1') {
    println("敲击了1");
  }
}
```

还有一些特殊的 key，如

- BACKSPACE 退格删除键
- TAB
- ENTER 回车键
- RETURN 回车键 老的 Mac 系统上可能使用的是 RETURN 回车键表示回车
- ESC 键盘左上角的 Escape 键
- DELETE 删除键

都可以直接进行比较：

```Java
void keyPressed() {
  if (key == BACKSPACE) {
    println("敲击了退格删除键");
  } else if (key == TAB) {
    println("敲击了 TAB 键");
  } else if (key == ENTER || key == RETURN) {
    println("敲击了回车键");
  } else if (key == ESC) {
    println("敲击了 ESC 键");
  } else if (key == DELETE) {
    println("敲击了删除键");
  }
}
```

## keyCode

key 处理不了的非 ASCII 码字符，使用 keyCode 来处理，但需要使用 `key == CODED` 来进行判断处理。这个`CODED`判断还是很重要的，像键盘 a/A ，'a' 的 ASCII 码是 97，'A' 的 ASCII 码是 65，但是这个按键敲击出来的 keyCode 都是 65。所以直接用 keyCode 判断等于某个值，会出现多个字符的可能性。我们通过判断`key == CODED`来首先判断是不是非 ASCII 码字符，再用`keyCode`判断就不容易出问题。

```Java
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      println("click 上");
    } else if (keyCode == DOWN) {
      println("click 下");
    } else if (keyCode == LEFT) {
      println("click 左");
    } else if (keyCode == RIGHT) {
      println("click 右");
    } else if (keyCode == CONTROL) {
      println("click Ctrl");
    } else if (keyCode == ALT) {
      println("click ALT");
    } else if (keyCode == SHIFT) {
      println("click SHIFT");
    }
  } else {
     println("click", key);
  }
}
```

## keyPressed

key 和 keyCode 是在`keyPressed()` 、`keyReleased()`、 `keyTyped()` 三个函数中使用，`keyPressed` 这个变量可以用在 draw 函数中，根据是否按下了键盘，实时的进行处理一些逻辑。

```Java
void draw() {
  if (keyPressed == true) {
    fill(0);
  } else {
    fill(255);
  }
  rect(25, 25, 50, 50);
}
```

## keyPressed()

每次按下一个键时都会调用一次 `keyPressed()` 函数。按下的键存储在 `key` 变量中。

对于非 ASCII 键，我们需要使用 `keyCode` 变量。

如果我们的程序需要在多平台如 Windows、Unix、Linux、Mac 上运行，还需注意 ENTER 键在 Windows 和 Unix 上常用，而 RETURN 键在 Mac 上使用。小菜测试自己的 Mac 电脑（Monterey 系统）用的其实是 ENTER 键来表示的回车，猜测在之前的系统上可能使用的是 RETURN 键表示。

由于操作系统处理键重复的方式，按住一个键可能会导致多次调用 keyPressed()。重复率由操作系统设置，并且可能在每台计算机上配置不同。关于这点的阐述可以看本文『按键的连续触发问题』

> 鼠标和键盘事件仅在程序具有 draw() 时才起作用。如果没有 draw()，代码只运行一次，然后停止监听事件。另外还要注意，是不能 `noLoop();`的，否则键盘事件也会不生效。

## keyReleased()

每次释放键时都会调用一次 `keyReleased()` 函数。

## keyTyped()

每次按下一个键时都会调用一次 keyTyped() 函数，但忽略 Ctrl、Shift 和 Alt 等操作键。 和keyPressed()一样，该函数也会收到操作系统按键处理重复频率的控制。按住一个键可能会导致多次调用 keyTyped()。重复率由操作系统设置，并且可能在每台计算机上配置不同。

## 按键的连续触发问题

```Java
void keyPressed() {
  if (key == '1') {
     println("按下1"); 
  }
}

void keyReleased() {
  if (key == '1') {
     println("松开1"); 
  }
}
```

大家看下这段代码，如果我们按下1马上松开，就会输出

```Java
按下1
松开1
```

但是如果我们按下1不松开呢？正常情况下就会不停的输出

```Java
按下1
按下1
按下1
按下1
按下1
按下1
按下1
按下1
...
```

由于操作系统处理键重复的方式，按住一个键可能会导致多次调用 keyPressed()。重复率由操作系统设置，并且可能在每台计算机上配置不同。

比如 Mac 电脑上的键盘的按键重复设置，如果关闭了按键重复，那么按住1不放，就只会输出一次。

![img](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/20211211112945.png)

调整按键重复的速度，可以看到控制台打印的 『按下1』的频率也会不同。小菜电脑配置的按键重复是最快，是因为经常有时候删除代码，要按住退格删除键不松开，让光标更快的进行移动删除。

我们的程序依赖电脑的『按键重复』配置是否关闭来控制按住键盘按键只触发一次，显然不太合理。每台电脑的配置可能是不同的，有的开启，有的关闭，且按键重复频率也可能有差异，这样就会导致程序在不同的电脑上表现不太一致。

而程序要做到通用性，该怎么处理呢？

我们很容易借助一个[HashMap]([https://processing.org/reference/HashMap.html](https://processing.org/reference/HashMap.html))来解决这个问题。

HashMap 的用法很简单，这个数据结构和数组有所不同，简单理解，一个坑（键）对应一个值（值），如 {"name": "小菜与老鸟", "sex": "男"}。

这里我们的 HashMap 字典的键的类型是 Character 字符类型，值是 Boolean 布尔类型。

思路：

- 如果按住了某个键，就将这个键的 key 当成字典的一个键存储起来，对应的值是 TRUE，表示我已经按住了这个键
- 当第二次按键要进行重复的时候，检测 HashMap 中这个字母的键是否已经已经设置了为 TRUE，如果有，则什么也不做，不会执行按压事件处理，这里的处理仅仅是打印下按下的键
- 当松开按键的时候，要将HashMap 中的该键的值还原成 FALSE，表示该键已经停止了按压

```Java
import java.util.Map;
HashMap<Character, Boolean> keys;

void setup() {
  size(400, 400);
  keys = new HashMap<Character, Boolean>();
}

void draw() {
  background(0);
}


void keyPressed() {
  // 如果已经敲击了键盘某个键，且字典里已经存在该 key 的值为 TRUE，则什么也不做
  if (keys.getOrDefault(key, Boolean.FALSE)) {
    // 啥也不做
  } else {
    keys.put(key, Boolean.TRUE);
    println("click " + key);
  }
}

void keyReleased() {
  keys.put(key, Boolean.FALSE);
  println("release " + key);
}
```

OK。关于键盘的常用处理就说到这，后续有其他，再继续更新。

大家周末愉快！


---------

『小菜与老鸟』会不定期更新 Processing 的学习思考以及源码分析的文章，欢迎关注不迷路。

如果有所收获，可以转发在看让更多的朋友看到么？

小菜建立了一个微信群，方便读者朋友们和小菜建立一个连接，群二维码在 2021/12/18 号之前有效，如果读者看到该二维码已经过期，可以扫码加小菜，备注 Processing，小菜拉你入群。

![](https://cdn.jsdelivr.net/gh/dabing1022/IMAGES_2021/2021/12/10/20211211133518.png)

![](https://gitee.com/Childhood/blog-pic-1/raw/master/2021/10/31/xiaocai.jpg)