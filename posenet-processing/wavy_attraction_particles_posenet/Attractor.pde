class Attractors {
  PVector pos;
  float r,R, o, min, max;

  Attractors() {
    pos = new PVector(random(width), random(height));
    

  }
  
  void update(float x, float y){
    pos.set(x,y);
  }
}
