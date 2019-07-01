// Rotating Table - Drivers of Change exhibition
// 2019 francesco.anselmo@arup.com

import processing.serial.*;
import gohai.glvideo.GLMovie;
import gohai.glvideo.PerspectiveTransform;
import gohai.glvideo.WarpPerspective;
import java.awt.geom.Point2D;

int NUMBER = 2;
float SCALING = 2.5;
int lf = 10;      // ASCII linefeed
//PImage[] sources = new PImage[NUMBER];
int selSource = 0;
GLMovie[] videos = new GLMovie[2];
GLMovie[] making_of_videos = new GLMovie[NUMBER];
String[] text_content = new String[NUMBER];
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
PFont f;

//int speed = 10000;
int speed = 1000;
float angle = 0;

void setup() {
  fullScreen(P2D);
  //fullScreen(P3D);
  //fullScreen(FX2D);
  noCursor();

  text_content[0] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ac ante pharetra est eleifend placerat eget vitae nulla. Morbi convallis consectetur nulla, eget luctus lacus euismod a. Fusce vel varius purus, non vulputate ipsum. Nunc eget sodales ipsum, a fermentum nulla. Phasellus auctor eu ipsum sit amet aliquet. Curabitur iaculis magna in justo imperdiet tincidunt. Fusce rutrum imperdiet diam, sit amet consequat nisl dictum eget.\nCurabitur eget ante nulla. Phasellus cursus lacus sapien, dapibus rhoncus mauris eleifend vel. Aliquam tempor commodo lectus, ut laoreet sapien mattis sed. Fusce ornare egestas ipsum, eu efficitur nulla efficitur nec. Morbi vel quam est. Vestibulum hendrerit magna elit, in sollicitudin metus porttitor quis. Sed sodales lobortis magna.";
  text_content[1] = "Curabitur molestie diam purus, in efficitur est pharetra id. Aenean nec nibh malesuada, aliquam magna at, vestibulum arcu. In nec commodo nisl. Aliquam massa dolor, hendrerit sit amet vehicula a, lobortis vel erat. Curabitur eleifend ultrices arcu, et mattis elit suscipit in. Aenean molestie tristique nulla, vitae ultrices lacus pharetra vitae. Vestibulum vitae arcu in turpis pellentesque finibus in sit amet justo. Quisque accumsan mollis tortor in vestibulum. Sed et nibh eget dolor porttitor semper. Sed tempor sodales sapien nec iaculis. Vivamus vestibulum volutpat erat et consectetur. Ut egestas eget odio ac mattis. Nullam ut metus magna. Donec eget tempor mi.\nAenean sit amet magna arcu. Suspendisse vel tincidunt sapien. Nunc id volutpat ex. Mauris pulvinar, eros in mollis bibendum, massa tortor ultricies libero, quis cursus lacus elit id arcu. Aliquam vulputate rutrum efficitur. Donec ut neque vitae sapien accumsan posuere eget sed erat. Fusce pellentesque dictum metus, sit amet aliquet nibh volutpat ac.";

  videos[0] = new GLMovie(this, "(un)balance.mp4");
  videos[0].loop();
  making_of_videos[0] = new GLMovie(this, "(un)balance - The making of.mp4");
  making_of_videos[0].loop();

  videos[1] = new GLMovie(this, "BirdSpace.mp4");
  videos[1].loop();
  videos[1].pause();
  
  making_of_videos[1] = new GLMovie(this, "BirdSpace - The Making of.mp4");
  making_of_videos[1].loop();
  making_of_videos[1].pause();

  // Create the font
  //printArray(PFont.list());
  f = createFont("Helvetica-Light", 18);
  textFont(f);
  fill(255);

  printArray(Serial.list());
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  val = myPort.readStringUntil(lf);
}

void draw() {
  background(0);

  if (videos[selSource].available()) {
    videos[selSource].read();
    making_of_videos[selSource].read();
  }


  // converting serial value
  //angle = millis()%speed/float(speed)*PI*2;
  try {
    if (val!=null) angle = (Integer.parseInt(val.replace("\r\n", "")))%speed/float(speed)*PI*2;
    int newSource = int((Integer.parseInt(val.replace("\r\n", "")))%speed/float(speed)*videos.length);
    if (newSource!=selSource) updateVideo(newSource, selSource);
    println("Serial value: "+val+"|"); //print it out in the console
  }

  catch (NumberFormatException e) {
    println("Serial communication value with problem:" +val+"|");
  }
  catch (NullPointerException e) {
    println("Null pointer exception");
  }

  //println("Angle: "+angle+"|"); //print it out in the console
  pushMatrix();

  int x = width/2;
  int y = height/2;
  translate(x, y);

  rotate(angle);

  if (millis()%50==0) println("Angle: "+angle);

  // show text, the text wraps within text box
  text(text_content[selSource], 0+width/50, height/SCALING/2/20, width/SCALING/2-width/50, height/SCALING/2*2); 

  // show main video
  image(videos[selSource], -width/SCALING/2, -height/SCALING*1.1, width/SCALING, height/SCALING);

  // show making of video
  image(making_of_videos[selSource], -width/SCALING/2, height/SCALING/2/20, width/SCALING/2, height/SCALING/2);

  popMatrix();
}

void updateVideo(int newSource, int curSource) {
  videos[curSource].pause();
  making_of_videos[curSource].pause();
  selSource = newSource;
  videos[selSource].loop();
  making_of_videos[selSource].loop();
  println("Source: "+selSource);
}

void changeVideo() {
  videos[selSource].pause();
  making_of_videos[selSource].pause();
  selSource = (selSource+1) % videos.length;
  videos[selSource].loop();
  making_of_videos[selSource].loop();
  println("Source: "+selSource);
}

//void mousePressed() {
//  changeVideo();
//}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n'); // read it and store it in val
}
