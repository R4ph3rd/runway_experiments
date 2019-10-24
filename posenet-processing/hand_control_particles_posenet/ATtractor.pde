class Attractors {
  PVector pos;
  float r,R, o, min, max;

  Attractors() {
    pos = new PVector(random(width), random(height));
    

  }
  
  void update(float x, float y){
    
    pos.lerp(new PVector(x,y), .2);
    
    pushStyle();
    fill(237, 157, 208);
    ellipse(pos.x, pos.y, 20, 20);
    popStyle();
  }
}
