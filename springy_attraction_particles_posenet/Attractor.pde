class Attractors {
  PVector pos, vel;
  float r,R, o, min, max;
  float g;

  Attractors(float _g) {
    pos = new PVector(random(width), random(height));
    vel = new PVector();
    g = _g;

  }
  
  void update(float x, float y){
    pos.set(x,y);
  }
}
