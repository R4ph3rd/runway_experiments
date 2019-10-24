class Particle {
  PVector pos, oldPos, vel, a, proxi; 
  float siz ;
  float d;

  Particle() {
    pos = new PVector(random(width), random(height));
    oldPos = new PVector(pos.x , pos.y);
    vel = new PVector();
    a = new PVector(random(-1,1), random(-1,1));
    proxi = new PVector();
    siz = random(2,5);
  }

  void update(int n) {
    
    oldPos.x = pos.x ;
    oldPos.y = pos.y ;
    
    //multiples to-reach points
    proxi.set(attractor.get(0).pos);
    
    d = dist(pos.x, pos.y, proxi.x, proxi.y);
    
    for (int i = 1 ; i < attractor.size() ; i ++){
      
      // attraction vers un noeud à partir d'une distance d ; on set les nouvelles valeurs
      if (dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y) < d){
        
        proxi.set(attractor.get(i).pos.x, attractor.get(i).pos.y) ;
        d = dist(pos.x, pos.y, attractor.get(i).pos.x, attractor.get(i).pos.y);
       
      }
    }
    
    a.set(proxi.x - pos.x, proxi.y - pos.y); 
    
    for (int j = n ; j < particles.length ; j ++){
      
       if( particles[j] == this) continue ;
               
       if ( dist( particles[j].pos.x, particles[j].pos.y, pos.x, pos.y) < 2 ){
         
          a = a.mult(-1) ; 
       }
    }
    
    //unique to-reach point
    a.limit(.3);
    
    vel.add(a);
    vel.limit(10);
    pos.add(vel);
  }
  

  void display() {
    pushStyle();
    strokeWeight(siz);
    stroke(255);
    line(oldPos.x, oldPos.y, pos.x, pos.y);
    popStyle();
   // oldPos.set(pos);
  }
}


/*class Particle {
  PVector pos, oldPos, vel, a; 
  float siz ;

  Particle() {
    pos = new PVector(random(width), random(height));
    oldPos = new PVector (pos.x, pos.y);
    vel = new PVector();
    a = new PVector();
    siz = random(0.5,3);
  }

  void update() {
    a = new PVector(mouseX - pos.x, mouseY - pos.y); 
    a.limit(.45);
    
    vel.add(a);
    vel.limit(10);
    pos.add(vel);
  }

  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(siz);
    //ellipse(pos.x, pos.y, siz, siz);
    line(pos.x, pos.y, oldPos.x, oldPos.y);
    popStyle();
    oldPos.x = pos.x ;
    oldPos.y = pos.y ;
  }
}

*/
