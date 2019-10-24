class Particle {
  PVector pos, vel, a, proxi ;
  int maxSpeed = 7 ;
  float d, siz;

  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector();
    a = new PVector();
    proxi = new PVector();
    siz = random(2,8);
  }
  
  void update(){
    

    //multiples to-reach points
    proxi.set(attractor.get(0).pos);
    
    d = dist(pos.x, pos.y, proxi.x, proxi.y);
    
    for (int i = 0 ; i < attractor.size() ; i ++){
      // attraction vers un noeud à partir d'une distance d ; on set les nouvelles valeurs
      if (dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y) < d){
        
        proxi.set(attractor.get(i).pos.x, attractor.get(i).pos.y) ;
        d = dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y);
       
      }
    }
    
    a = proxi.sub(pos); 
    a.setMag(1.8 / sqrt(d));
    vel.add(a);
    vel.limit(maxSpeed);
    pos.add(vel);
  }
  
  
  void checkScreen(){
     if( pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height ) a.mult(-1) ; 
  }
 
 void display(){
    point(pos.x, pos.y);
 }
 
}
