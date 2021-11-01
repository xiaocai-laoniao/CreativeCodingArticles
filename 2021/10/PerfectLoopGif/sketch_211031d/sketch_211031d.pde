void setup() {
  size(704, 200, P2D);
  frameRate(30);
  noStroke();
}

void draw() {
  background(0);
  for (float i = 0; i < 1; i += 1 / 16.0) {
    float barheight = inOutSin(tri(timeLoop(60, i * 60))) * 100;
    rect(36 + i * 640, 150 - barheight, 32, barheight);
  }
}

float timeLoop(float totalframes, float offset) {
  return (frameCount + offset) % totalframes / totalframes;
}

float tri(float t) {
  return t < 0.5 ? t * 2 : 2 - (t * 2);
}

float inOutSin(float t) {
  return 0.5 - cos(PI * t) / 2;
}
