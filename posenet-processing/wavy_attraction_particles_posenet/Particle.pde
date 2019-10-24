class Particle {
  PVector pos, vel, a, proxi ;
  int maxSpeed = 9 ;
  float d, siz;
  //Spring effect
  float len, stiffness, damping ;
  PVector myNode, spring ;

  Particle(PVector nodeOfSpring) {
    pos = new PVector(random(width), random(height));
    vel = new PVector();
    a = new PVector();
    proxi = new PVector();
    siz = random(2,8);
    len = random(200, 1200);
    stiffness = random(0.3, 0.8);
    damping = random(0.7, 0.99);
    myNode = nodeOfSpring;
    spring = new PVector();
  }
  
  
  void spring(){
     PVector diff = PVector.sub(pos, myNode);
     diff.normalize();
     diff.mult(len);
     PVector target = PVector.add(pos, diff);
     
     PVector force = PVector.sub(target, myNode);
     force.mult(.5);
     force.mult(stiffness);
     force.mult(1 - damping);
     
     
     vel.add(PVector.mult(force, -1));
     vel.limit(maxSpeed);
     pos.add(vel);
  }
  
  void checkScreen(){
     if( pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height ) a.mult(-1) ; 
  }
 
 void display(){
    ellipse(pos.x, pos.y, siz, siz);
 }
 
}
