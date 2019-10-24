// Copyright (C) 2019 RunwayML Examples
// 
// This file is part of RunwayML Examples.
// 
// Runway-Examples is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Runway-Examples is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model

// Import OSC
import oscP5.*;
import netP5.*;

JSONObject data;
JSONArray humans;

String[][] connections = {
  {"nose", "leftEye"},
  {"leftEye", "leftEar"},
  {"nose", "rightEye"},
  {"rightEye", "rightEar"},
  {"rightShoulder", "rightElbow"},
  {"rightElbow", "rightWrist"},
  {"leftShoulder", "leftElbow"},
  {"leftElbow", "leftWrist"}, 
  {"rightHip", "rightKnee"},
  {"rightKnee", "rightAnkle"},
  {"leftHip", "leftKnee"},
  {"leftKnee", "leftAnkle"}
};

/*
["nose","leftEye1","rightEye","leftEar3",
"rightEar","leftShoulder5","rightShoulder",
"leftElbow7","rightElbow","leftWrist9",
"rightWrist","leftHip11","rightHip","leftKnee13",
"rightKnee","leftAnkle15","rightAnkle"]
*/

OscP5 oscP5;
NetAddress myBroadcastLocation;


// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

ArrayList<Attractors> attractor = new ArrayList<Attractors>();
Particle [] particles = new Particle[5000];
int maxP = 5000 ;

void setup() {
  size(displayWidth, displayHeight,P2D);
  background(0);
  stroke(0,0,240);
  noCursor();

  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);

  // Use the localhost and the port 57100 that we define in Runway
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(#FEFFC9);
  stroke(255);

  //multiples to-reach points
  for (int i = 0; i < 1; i ++) {
    attractor.add(new Attractors());
  }

  for (int i = 0; i < particles.length; i++) particles[i] = new Particle();

}

void draw() {

  pushStyle();
  noStroke();
  fill(#101636, 25);
  rect(0, 0, width, height);
  popStyle();
    
  if (data != null) {
    humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for (int k = 9 ; k < 11 ; k++) {
        
        if ( k == 9 || k == 10 ){
            // Body parts are relative to width and weight of the input
            JSONArray point = keypoints.getJSONArray(k);
            float x = map(point.getFloat(0), 0, 1, width, 0);
            float y = map(point.getFloat(1), 0, 1, 0, height);            
        
              if ( attractor.size() < 2) {
                attractor.add( new Attractors());
              } else if ( attractor.size() > 2) {
                attractor.remove( new Attractors());
              }

              Attractors refresh = attractor.get(k - 9);
              refresh.update(x, y);
         }
       }
    }
  }

/*
     pushStyle();
     noFill();
     stroke(255, 0, 0);
     
     if (attractor.size() >= 5){
       beginShape();
       vertex(attractor.get(1).pos.x, attractor.get(1).pos.y);
       vertex(attractor.get(3).pos.x, attractor.get(3).pos.y);
       vertex(attractor.get(5).pos.x, attractor.get(5).pos.y);
       endShape();
     }
     
     if (attractor.size() >= 6){
       beginShape();
       vertex(attractor.get(2).pos.x, attractor.get(2).pos.y);
       vertex(attractor.get(4).pos.x, attractor.get(4).pos.y);
       vertex(attractor.get(6).pos.x, attractor.get(6).pos.y);
       endShape();
     }
     
     if (attractor.size() >= 8){
       beginShape();
       vertex(attractor.get(1).pos.x, attractor.get(1).pos.y);
       vertex(attractor.get(2).pos.x, attractor.get(2).pos.y);
       vertex(attractor.get(8).pos.x, attractor.get(8).pos.y);
       vertex(attractor.get(7).pos.x, attractor.get(7).pos.y);
       endShape(CLOSE);
     }
     
     if (attractor.size() >= 2){
       
       
     
      PVector center = new PVector ((attractor.get(1).pos.x + attractor.get(2).pos.x) / 2, (attractor.get(1).pos.y + attractor.get(1).pos.y) / 2 );
     line(attractor.get(0).pos.x, attractor.get(0).pos.y, center.x, center.y );
     
     ellipse( attractor.get(0).pos.x, attractor.get(0).pos.y, 300, 300);
     }
     
     popStyle();
     
*/

  //to keep a fluid render
  float fps = frameRate;
  if (maxP < 5000 ){
     if (fps < 30) maxP -= 10 ;
     else if ( fps > 40 ) maxP += 10 ;
  }

  
  
  for (int i = 0 ; i < maxP ; i ++){
      //particles[i].spring();
      particles[i].update();
      particles[i].checkScreen();
      particles[i].display();
  }
  
}



void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() {
  switch(key) {
    case('c'):
      /* connect to Runway */
      connect();
      break;
    case('d'):
      /* disconnect from Runway */
      disconnect();
      break;
    case(ENTER):
      for (int i = 0; i < particles.length; i++) particles[i] = new Particle();
      break;

  }
}



// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  if (!theOscMessage.addrPattern().equals("/data")) return;
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
}
