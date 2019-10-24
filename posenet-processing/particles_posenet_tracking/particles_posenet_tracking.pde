/*
JSON extraction from Runway made by Berenger Recoules https://github.com/b2renger/workshop_ml_PCD2019/blob/master/runway_processing_osc/receive_posenet/receive_posenet.pde
 */
// Import OSC
import oscP5.*;
import netP5.*;

// Runway Parameters
String runwayHost = "127.0.0.1";
int runwayPort = 57100;
int camWidth = 600;
int camHeight = 400;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans, keypoints;
JSONObject human, body_part, positions ;

float xScreen, yScreen, x, y;

// This are the pair of body connections we want to form. 
// Try creating new ones!
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

Particle [] particles = new Particle[1500];
ArrayList<Attractors> attractor = new ArrayList<Attractors>();

void setup() {
  size(displayWidth, displayHeight,P2D);
  background(0);
  noStroke();
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

  fill(255);
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
  fill(0, 25);
  rect(0, 0, width, height);
  popStyle();

  if (data != null) {
    humans = data.getJSONArray("poses");
    for (int h = 0; h < humans.size(); h++) {
      human = humans.getJSONObject(h);
      keypoints = human.getJSONArray("keypoints");



      // Now that we have one human, let's draw its body parts
      for (int k = 0; k < keypoints.size(); k++) {
        body_part = keypoints.getJSONObject(k);
        positions = body_part.getJSONObject("position");
        // Body parts are relative to width and weight of the input
        x = positions.getFloat("x");
        y = positions.getFloat("y");
        // map coordinates from camera resolution to screen resolution
        xScreen = map(x, 0, camWidth, width, 0); // inverse x coordinates
        yScreen = map(y, 0, camHeight, 0, height);

        if ( attractor.size() < keypoints.size()) {
          attractor.add( new Attractors());
        } else if ( attractor.size() > keypoints.size()) {
          attractor.remove( new Attractors());
        }

        Attractors refresh = attractor.get(k);
        refresh.update(xScreen, yScreen);
        
        noStroke();
        fill(255, 0, 0);
        ellipse(xScreen, yScreen, 10, 10);

      }
    }
  }




  for ( int w = 0; w < particles.length; w++) {
    particles[w].update(w); 
    particles[w].display();
  }
}


void keyPressed() {
  if (keyCode == ENTER) {
    for (int i = 0; i < particles.length; i++) particles[i] = new Particle();
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


// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
  // println(data);
}
