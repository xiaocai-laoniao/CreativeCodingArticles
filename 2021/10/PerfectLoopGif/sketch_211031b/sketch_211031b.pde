void setup() {
  size(704, 150);
  frameRate(30);
}

void draw() {
  background(0);
  fill(255);
  rect(timeLoop(60, 0) * width, 30, 30, 30);
  rect(timeLoop(60, 20) * width, 60, 30, 30);
  rect(timeLoop(60, 40) * width, 90, 30, 30);
}

float timeLoop(float nFramesInLoop, float offset) {
  return (frameCount + offset) % nFramesInLoop / nFramesInLoop;
}
