void setup() {
  size(704, 90);
  frameRate(30);
}

void draw() {
  background(0);
  fill(255);
  rect(timeLoop(60) * width, 30, 30, 30);
}

float timeLoop(float nFramesInLoop) {
  return frameCount % nFramesInLoop / nFramesInLoop;
}
