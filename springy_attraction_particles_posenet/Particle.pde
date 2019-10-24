class Particle {
  PVector pos, vel, a, proxi ;
  int maxSpeed = 7 ;
  float d, siz;
  //Spring effect
  float len, stiffness, damping ;
  PVector myNode, spring ;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector();
    a = new PVector();
    proxi = new PVector();
    siz = random(2,8);
    len = random(200, 600);
    stiffness = random(0.3, 0.8);
    damping = random(0.6, 0.95);
    myNode = new PVector();
    spring = new PVector();
  }
  
  void update(){
    

    //multiples to-reach points
    proxi.set(attractor.get(0).pos);
    
    d = dist(pos.x, pos.y, proxi.x, proxi.y);
    float s = 1;
    
    for (int i = 1 ; i < attractor.size() ; i ++){
      // attraction vers un noeud à partir d'une distance d ; on set les nouvelles valeurs
      if (dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y) < d * s){
        
        s = attractor.get(i).g;
        
        proxi.set(attractor.get(i).pos.x, attractor.get(i).pos.y) ;
        d = dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y);
       
      }
    }
    
    myNode.set(proxi);
    a = proxi.sub(pos); 
    a.setMag((1.8 / sqrt(d) ) * s);
    vel.add(a);
    vel.limit(maxSpeed);
    pos.add(vel);
    //pos.add(spring);

    

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
     myNode.add(force);
     spring.sub(PVector.mult(force, - 1));
     spring.limit(100);
  }
  
  void checkScreen(){
     if( pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height ) a.mult(-1) ; 
  }
 
 void display(){
    ellipse(pos.x, pos.y, siz, siz);
 }
 
}
