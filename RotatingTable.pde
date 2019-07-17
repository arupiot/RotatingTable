// Rotating Table - Drivers of Change exhibition
// 2019 francesco.anselmo@arup.com

import processing.serial.*;
import gohai.glvideo.GLMovie;
import gohai.glvideo.PerspectiveTransform;
import gohai.glvideo.WarpPerspective;
import java.awt.geom.Point2D;
import processing.video.*;

boolean USE_SERIAL = true;
int NUMBER = 9;
float SCALING = 2.5;
int FONT_SIZE = 20;
int FONT_SIZE_BIG = 30;
int IDLE_TIME = 12*1000;
float VOLUME_LEVEL = 0.2;

enum Status {
  RUNNING, 
    IDLE
}

int steps = 4800;
float speed = 0.2;
Status status = Status.IDLE;
int prevTime = 0;
float prevAngle= 0;

int lf = 10;      // ASCII linefeed
int selSource = 0;
int newSource = 0;

//GLMovie[] videos = new Movie[NUMBER];
//GLMovie[] making_of_videos = new Movie[NUMBER];

Movie[] videos = new Movie[NUMBER];
Movie[] making_of_videos = new Movie[NUMBER];
Movie screensaver;

String[] text_title = new String[NUMBER];
String[] text_author = new String[NUMBER];
String[] text_url = new String[NUMBER];
String[] text_content = new String[NUMBER];
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
PFont f, fb, ft;

float angle = 0;
float angleDeg = 0;
float angleDegEnd = 0;
float percentMovement = 0;
int fading = 255;

void setup() {
  //fullScreen();
  fullScreen(P2D);
  //fullScreen(P3D);
  //fullScreen(FX2D);
  noCursor();

  screensaver = new Movie(this, "Home_page_2.mp4");
  // screensaver = new Movie(this, "(Un)Balance.mp4");

  screensaver.loop();
  screensaver.pause();

  text_author[0] = "Elyne Legarnisson";
  text_title[0] = "(Un)Balance";
  text_url[0] = "http://www.interactivearchitecture.org/lab-projects/unbalance";
  text_content[0] = "(Un)Balance is an interactive experience in XR (extended reality) inviting participants to play on the edge of stability. Virtual and physical tools combine to create an alternative reality which provokes participants to break habitual movement patterns. The XR experience extends body awareness through augmenting and shifting the perception of one’s body and the world.";

  videos[0] = new Movie(this, "(un)balance.mp4");
  videos[0].loop();
  videos[0].volume(VOLUME_LEVEL);
  making_of_videos[0] = new Movie(this, "(un)balance - The making of.mp4");
  making_of_videos[0].loop();
  making_of_videos[0].volume(0);

  text_author[1] = "Huisim Chan";
  text_title[1] = "Neoteny";
  text_url[1] = "http://www.interactivearchitecture.org/lab-projects/neoteny";
  text_content[1] = "Neoteny aims to provoke debates about current notions of transhumanism Adorning the wearer’s head, Neoteny is part piece of jewellery, part wearable. The project uses the body of the designer as a site for enhancing memories by referencing body movements with olfactory stimuli. Neoteny uses bio-sensing to detect muscle activity levels to trigger the blending and delivery of personalised scents to the wearer. This has the effect of encouraging associative cross-sensory connections and acts as a memory reinforcement and retention paradigm.";

  videos[1] = new Movie(this, "Neoteny.mp4");
  videos[1].loop();
  videos[1].pause();
  making_of_videos[1] = new Movie(this, "Neoteny - The making of.mp4");
  making_of_videos[1].loop();
  making_of_videos[1].volume(0);
  making_of_videos[1].pause();

  text_author[2] = "Christine Würth";
  text_title[2] = "NeoTouch";
  text_url[2] = "http://www.interactivearchitecture.org/lab-projects/neotouch";
  text_content[2] = "NeoTouch is a speculative project envisioning the future of haptic technology in the form of a communication device that allows touch at a distance by stimulating relevant brain areas. The technology is sited in a near future in which current issues around digital privacy and physical safety coincide. NeoTouch explores the effects of digital technologies on our perception of self, identity, and interpersonal interactions.";

  videos[2] = new Movie(this, "NeoTouch Technology.mp4");
  videos[2].loop();
  videos[2].pause();
  making_of_videos[2] = new Movie(this, "NeoTouch - The Making of.mp4");
  making_of_videos[2].loop();
  making_of_videos[2].volume(0);
  making_of_videos[2].pause();

  text_author[3] = "Ahrian Taylor & Eugenio Moggio";
  text_title[3] = "Nero";
  text_url[3] = "http://www.interactivearchitecture.org/lab-projects/nero";
  text_content[3] = "Nero (νερό, Greek for water) is an immersive Virtual Reality experience centred around embodied learning environments. Here, you are Nero, a virtual character that explores an Atlantis-themed environment whilst on a journey to learn about the process of evaporation. Through completing a series of small tasks, Nero builds up an understanding of the separate elements involved in evaporation. The narrative arch of the game culminates in Nero being rewarded upon completing the final task with cohesive knowledge of the overall process.";

  videos[3] = new Movie(this, "Nero.mp4");
  videos[3].loop();
  videos[3].pause();
  making_of_videos[3] = new Movie(this, "Nero - The making of.mp4");
  making_of_videos[3].loop();
  making_of_videos[3].volume(0);
  making_of_videos[3].pause();

  text_author[4] = "Parker Heyl";
  text_title[4] = "Analog Future";
  text_url[4] = "http://www.interactivearchitecture.org/lab-projects/analog-future";
  text_content[4] = "This project questions the use of emerging technologies in contemporary music, art, and architectural practices and our notions of spatiality in translating from the physical to the virtual. A holistic cybernetic fantasy blurs the line between the virtual and the real. The physical object is slowly tranquilized and replaced with less potent simulacra of itself. Interactive algorithms have largely informed modern conceptions of intelligence, thus ignoring the ways in which naturally-occurring physical systems also form networks encoded with complex information. Against this trend, Analog Future seeks to relinquish computerised regulation in favour of an analog aesthetic.";

  videos[4] = new Movie(this, "Analog Future-2.mp4");
  videos[4].loop();
  videos[4].pause();
  making_of_videos[4] = new Movie(this, "Analog Future - The making of.mp4");
  making_of_videos[4].loop();
  making_of_videos[4].volume(0);
  making_of_videos[4].pause();

  text_author[5] = "Michael Wagner";
  text_title[5] = "Marble Maze";
  text_url[5] = "http://www.interactivearchitecture.org/lab-projects/marble-maze";
  text_content[5] = "As stage technology evolves to be more of an immersive experience rather than just framing performance, this work questions whether the stage, as well as the performance, could not also change and rearrange their spatial relationship with the audience. Could the technology available today be used to fragment and distribute a performance across a single auditorium or even across multiple spaces?";

  videos[5] = new Movie(this, "Marble Maze.mov");
  videos[5].loop();
  videos[5].pause();
  making_of_videos[5] = new Movie(this, "Marble Maze - The making of.mp4");
  making_of_videos[5].loop();
  making_of_videos[5].volume(0);
  making_of_videos[5].pause();

  text_author[6] = "Luyang Zou & Yildiz Tufan";
  text_title[6] = "Phonon";
  text_url[6] = "http://www.interactivearchitecture.org/lab-projects/phonon";
  text_content[6] = "Phonon is an audio-visual landscape that celebrates stillness and slowness. The name ‘Phonon’ denotes the smallest unit of acoustic energy. The installation encourages visitors to take time to experience their environment through stillness, instead of consuming media voraciously to be forgotten with the next swipe. Visual illusionary cues, projection mapping and spatial sound techniques transform the physical space into an immersive environment that represents an abstract cityscape. When uninhabited, the space reconfigures over time by looping through the generated spaces of previous users, waiting to be explored by another.";

  videos[6] = new Movie(this, "Phonon.mp4");
  videos[6].loop();
  videos[6].pause();
  making_of_videos[6] = new Movie(this, "Phonon - The making of.mp4");
  making_of_videos[6].loop();
  making_of_videos[6].volume(0);
  making_of_videos[6].pause();


  text_author[7] = "Naomi Lea";
  text_title[7] = "Felt Presence";
  text_url[7] = "http://www.interactivearchitecture.org/lab-projects/felt-presence";
  text_content[7] = "Described by Neurologist Olaf Blanke as the strange sensation that somebody is nearby when no one is present, Feeling of Presence (FoP) is often associated with neurological disorders or spiritual encounters, and yet there is limited research on its experience among healthy individuals.  Visitors experience their own shadow emerging from their body, gradually acquiring a sense of its own agency through visual and haptic sensorimotor disturbances to induce an evolving FoP experience.";

  videos[7] = new Movie(this, "Yours Shadow.mp4");
  videos[7].loop();
  videos[7].pause();
  making_of_videos[7] = new Movie(this, "Yours Shadow - The making of.mp4");
  making_of_videos[7].loop();
  making_of_videos[7].volume(0);
  making_of_videos[7].pause();

  text_author[8] = "Vasilija Abramovic, Bas Overvelde & Ruairi Glynn";
  text_title[8] = "Edge of Chaos";
  text_url[8] = "http://www.interactivearchitecture.org/lab-projects/edge-of-chaos";
  text_content[8] = "Scientists are recognising that the transition space between order and disorder known as Edge of Chaos displays complex behaviours within it. The continuous flux between organisation and instability may be what drives the engine of life and produces the boundless novelty of the natural world. This interactive installation invites visitors to experience the balancing point between highly ordered and turbulent systems. At its centre is a robotic tree representing Life, surrounded by an inert Cloud representing the vast unorganised matter of an entropic universe, and an interactive surface that represents the Edge of Chaos.";

  videos[8] = new Movie(this, "Edge of Chaos.mp4");
  videos[8].loop();
  videos[8].pause();
  making_of_videos[8] = new Movie(this, "Making of Edge of Chaos.mp4");
  making_of_videos[8].loop();
  making_of_videos[8].volume(0);
  making_of_videos[8].pause();

  // Create the font
  //printArray(PFont.list());
  f = createFont("Helvetica-Light", FONT_SIZE);
  fb = createFont("Helvetica-Light", FONT_SIZE_BIG);
  ft = createFont("Helvetica", FONT_SIZE_BIG*1.5);
  textFont(f);
  fill(255);

  if (USE_SERIAL) {
    printArray(Serial.list());
    String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
    myPort = new Serial(this, portName, 9600);
    val = myPort.readStringUntil(lf);
  }
  //prevTime = millis();

  status = Status.IDLE;
}

void draw() {
  background(0);

  if (videos[selSource].available()) {
    videos[selSource].read();
    making_of_videos[selSource].read();
  }

  if (screensaver.available()) {
    screensaver.read();
  }

  // converting serial value
  if (USE_SERIAL) {
    try {
      if (val!=null) angle = (Integer.parseInt(val.replace("\r\n", "")))%steps/float(steps)*PI*2;
      newSource = int((Integer.parseInt(val.replace("\r\n", "")))%steps/float(steps)*videos.length);
      if (newSource!=selSource) updateVideo(newSource, selSource);
      if (angle != prevAngle) {
        prevTime = millis();
        prevAngle = angle;
      }

      println("Serial value: "+val+"|"); //print it out in the console
    }
    catch (NumberFormatException e) {
      println("Serial communication value with problem:" +val+"|");
    }
    catch (NullPointerException e) {
      println("Null pointer exception");
    }
  } else {
    //angle = (millis()*speed)%(steps*10)/float(steps*10)*PI*2;
    angle = (mouseX)%(width)/float(width)*PI*2;
    newSource = int(angle/PI/2*10000%(steps*10)/float(steps*10)*videos.length);

    //println("Percent movement: "+percentMovement);
  }

  angleDeg = angle/PI*180;
  if (selSource < videos.length) angleDegEnd = 360.0/videos.length*(selSource+1);
  else angleDegEnd = 360.0;
  float angleDegStart = (360.0/videos.length)*(selSource);
  percentMovement = (angleDeg-angleDegStart)/(360.0/videos.length)*100;
  println("New Source: " + newSource + " | Sel Source: " + selSource);
  if (percentMovement <= 20) fading = int(percentMovement/20*255);
  if (percentMovement >= 80) fading = int((100-percentMovement)/20*255);
  if (newSource!=selSource) updateVideo(newSource, selSource);


  //println("Angle: "+angle+"|"); //print it out in the console
  //pushMatrix();

  if (millis()-prevTime > IDLE_TIME ) status = Status.IDLE;
  else status = Status.RUNNING;

  if (millis()%10==0) println("Angle: "+angle+" | Percent movement: "+percentMovement+" | Angle degrees: "+angleDeg+" | Angle end: "+angleDegEnd);

  println("Status: "+status+" | "+millis()+" | "+prevTime+" | "+IDLE_TIME+" | "+(millis()-prevTime));

  if (status == Status.IDLE) {
    tint(255, 255);
    image(screensaver, 0, 0, width, height);
    screensaver.loop();
    for (int i=0; i<videos.length; i++) {
      making_of_videos[i].volume(0);
      videos[i].volume(0);
    }
    textFont(ft);
    text("Turn the table to select a project", width/2-300, height/4*3);
  } else {
    screensaver.pause();
    int x = width/2;
    int y = height/2;
    translate(x, y);


    stroke(255);
    pushMatrix();
    rotate((TWO_PI/videos.length)*5);
    for (int i = 0; i < videos.length; i++) {  
      pushMatrix();
      float rad = i*TWO_PI/videos.length;
      rotate(rad);
      translate(0, -height/2);
      line(0, 0, 0, 46);
      //text_title[i]
      pushMatrix();
      rotate(PI);
      text(text_title[i], 5, -30);
      popMatrix();
      popMatrix();
    }
    popMatrix();
    noStroke();


    rotate(angle);

    tint(255, fading);
    // show main video
    stroke(255);

    image(videos[selSource], -width/SCALING/2, -height/SCALING*0.8, width/SCALING, height/SCALING);


    /////////////// Crosshairs //////////////

    int tSize=40;
    line(-width/SCALING/2, (-height/SCALING*0.8)-tSize, -width/SCALING/2, (-height/SCALING*0.8)+tSize);
    line((-width/SCALING/2)-tSize, -height/SCALING*0.8, (-width/SCALING/2)+tSize, -height/SCALING*0.8);

    line((-width/SCALING/2) + (width/SCALING), (-height/SCALING*0.8)-tSize, (-width/SCALING/2) + (width/SCALING), (-height/SCALING*0.8)+tSize);
    line((-width/SCALING/2) + (width/SCALING)-tSize, (-height/SCALING*0.8), (-width/SCALING/2) + (width/SCALING)+tSize, (-height/SCALING*0.8));

    line((-width/SCALING/2)-tSize, (-height/SCALING*0.8)+(height/SCALING), (-width/SCALING/2)+tSize, (-height/SCALING*0.8)+(height/SCALING));
    line((-width/SCALING/2), (-height/SCALING*0.8)+(height/SCALING)-tSize, (-width/SCALING/2), (-height/SCALING*0.8)+(height/SCALING)+tSize);

    line((-width/SCALING/2) + (width/SCALING), (-height/SCALING*0.8)+(height/SCALING)-tSize, (-width/SCALING/2) + (width/SCALING), (-height/SCALING*0.8)+(height/SCALING)+tSize);
    line((-width/SCALING/2) + (width/SCALING)-tSize, (-height/SCALING*0.8)+(height/SCALING), (-width/SCALING/2) + (width/SCALING)+tSize, (-height/SCALING*0.8)+(height/SCALING));
    int tempVal=609;
    line(0, tempVal, 0, 1020);
    line(0-tSize, tempVal+tSize, 0+tSize, tempVal+tSize);
    noStroke();

    ///////////////////////////////////////////////////////


    // show making of video
    image(making_of_videos[selSource], -width/SCALING/2, height/SCALING/2/2, width/SCALING/2, height/SCALING/2);

    //line(-width/SCALING/2, height/SCALING/2/2, -width/SCALING/2, height/SCALING/2/2, height/SCALING/2);

    // show author and title
    textFont(fb);
    fill(255, 255, 255, fading);
    text(text_author[selSource]+" - "+text_title[selSource], 0+width/50, height/SCALING/2/2+FONT_SIZE_BIG);

    // shor url
    textFont(f);
    text(text_url[selSource], 0+width/50, height/SCALING/2/2+FONT_SIZE_BIG*2);

    // show text, the text wraps within text box
    text(text_content[selSource], 0+width/50, height/SCALING/2/2+FONT_SIZE_BIG*3, width/SCALING/2-width/50, height/SCALING/2*2); 
    tint(255, 255);
    fill(255, 255, 255, 255);

    //popMatrix();
  }
}

void updateVideo(int newSource, int curSource) {
  videos[curSource].pause();
  making_of_videos[curSource].pause();
  selSource = newSource;
  videos[selSource].loop();
  videos[selSource].volume(VOLUME_LEVEL);
  making_of_videos[selSource].loop();
  println("Source: "+selSource);
  //prevTime = millis();
}

//void changeVideo() {
//  videos[selSource].pause();
//  making_of_videos[selSource].pause();
//  selSource = (selSource+1) % videos.length;
//  videos[selSource].loop();
//  making_of_videos[selSource].loop();
//  println("Source: "+selSource);
//}

//void mousePressed() {
//  changeVideo();
//}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n'); // read it and store it in val
}
