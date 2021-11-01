void setup() {
  size(704, 200);
  frameRate(30);
  noStroke();
}

void draw() {
  background(0);
  fill(255);
  background(0);
  for (float i = 0; i < 1; i += 1 / 16.0) {
    float barheight = timeLoop(60, i * 60) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
  }
}

float timeLoop(float nFramesInLoop, float offset) {
  return (frameCount + offset) % nFramesInLoop / nFramesInLoop;
}
