import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;
Knob batteryKnob;

PrintWriter data;
PFont f1;
PImage conexalab_img;
PImage mamus_img;
PImage dreamer_img;
PImage bateria_img;
PImage arrow_img;

int s1Off = 0;      //set start state off
int s2Off = 0;
int launcherOff = 0;
String launcherState = "OFF";
int launcherXcoordinate = 790;      //establishes coordinates to shift and center text
int launcherYcoordinate = 440;

//line graph widths
int[] fuerzaNumbers = new int[446];
int[] temp1Numbers = new int[298];
int[] temp2Numbers = new int[298];
int[] temp3Numbers = new int[298];
int[] temp4Numbers = new int[298];

//serial read
int[] messages = new int[9];
/*
messages[0] = temp 1 (0-400)
messages[1] = temp 2 (0-400)
messages[2] = temp 3 (0-400)
messages[3] = temp 4 (0-1000)
messages[4] = fuerza (0-600)
messages[5] = S1 (0-1)
messages[6] = S2 (0-1)
messages[7] = bateria (0-100)
messages[8] = launcher (0-1)
*/

void setup() {
  size(1024, 600);      //Initialize the size of the dashboard
  smooth();
  noStroke();
  cp5 = new ControlP5(this);
  //String portName = Serial.list()[1];
  myPort = new Serial(this, "/dev/cu.usbserial-0001", 9600);
  
  //create font and images
  f1 = createFont("DINAlternate-Bold-48", 76, true);      // Set font type and size
  
  data = createWriter("dreamerData.txt"); 
  
  conexalab_img = loadImage("conexalab_logo.png");
  mamus_img = loadImage("mamus_logo.png");
  dreamer_img = loadImage("dreamer_logo.png");
  bateria_img = loadImage("bateria_logo.png");
  arrow_img = loadImage("arrow_logo.png");
  
  //battery knob create and modify
  batteryKnob = cp5.addKnob("")
    .setRange(0, 100)
    .setValue(100)
    .setPosition(860, 242)
    .setRadius(40)
    .setDragDirection(Knob.VERTICAL)
    .setNumberOfTickMarks(10)
    .setColorBackground(color(19, 34, 44));
}

void draw() {
  background(48, 60, 68);
  
  // Read serial data
  while (myPort.available() > 0) {
    String comunicacion = myPort.readStringUntil('\n'); // Read until newline character
    if (comunicacion != null) {
      comunicacion = comunicacion.trim(); // Remove leading/trailing whitespaces
      parseSerialData(comunicacion); // Parse the received data
      data.println(comunicacion); // Save the raw data to file
    }
  }
  
  // Draw the dashboard elements
  drawDashboard();
}

void parseSerialData(String data) {
  String[] values = data.split(";");
  if (values.length == 9) {
    for (int i = 0; i < values.length; i++) {
      messages[i] = Integer.parseInt(values[i]);
    }
  }
}

void drawDashboard() {
  // Your existing code for drawing the dashboard elements goes here
  
  //temp 1,2,3 code
  fill(19,34,44);
  rect(32,17,298,150);      //temp 1,2,3 box
  fill(11,22,30);
  rect(32,17,298,40);      //temp 1,2,3 title box
  fill(255,255,255);
  textFont(f1);
  textSize(20);
  text("TEMPERATURAS 1-2-3", 70, 45);      //temp 1-2-3 text
  textSize(10);
  text("300", 50, 80.75);
  text("200", 50, 101.5);
  text("100", 50, 122.25);
  pushStyle();
  stroke(255,255,255);      //set the stroke (line) color to white
  strokeWeight(2);      
  line(80,77.75,84,77.75);     //mini - lines  
  line(80,98.5,84,98.5);     //mini - lines  
  line(80,119.25,84,119.25);     //mini - lines 
  popStyle();
  
  //temp1 line graph
  pushStyle();
  stroke(255, 255, 255); // set the stroke (line) color to black
  strokeWeight(2); // set the stroke width (weight) for the axes
  line(32,140,330,140);     //draw the x-axis line            
  line(82,57,82,167); 
  noFill();
  stroke(0, 255, 255); // sets line color

  beginShape();
  for (int i = 0; i < temp1Numbers.length; i++) { //modified +1 //same below
    float x = map(i, 0, temp1Numbers.length - 1, 32, 330);
    float y = map(temp1Numbers[i], 0, 400, 140, 57);
    vertex(x, y);
  }
  endShape();

  for (int i = 1; i < temp1Numbers.length; i++) { //modified
    temp1Numbers[i - 1] = temp1Numbers[i];
  }

  temp1Numbers[temp1Numbers.length - 1] = messages[0]; //set value
  popStyle();
  
  //temp2 line graph
  pushStyle();
  strokeWeight(2); // set the stroke width (weight) for the axes
  noFill();
  stroke(255, 153, 0); // sets line color
  beginShape();
  for (int i = 0; i < temp2Numbers.length; i++) {
    float x = map(i, 0, temp2Numbers.length - 1, 32, 330);
    float y = map(temp2Numbers[i], 0, 400, 140, 57);
    vertex(x, y);
  }
  endShape();
  for (int i = 1; i < temp2Numbers.length; i++) {
    temp2Numbers[i - 1] = temp2Numbers[i];
  }
  temp2Numbers[temp2Numbers.length - 1] = messages[1]; //set value
  popStyle();
  
  //temp3 line graph
  pushStyle();
  strokeWeight(2); // set the stroke width (weight) for the axes
  noFill();
  stroke(255, 255, 0); // sets line color
  beginShape();
  for (int i = 0; i < temp3Numbers.length; i++) {
    float x = map(i, 0, temp3Numbers.length - 1, 32, 330);
    float y = map(temp3Numbers[i], 0, 400, 140, 57);  
    vertex(x, y);
  }
  endShape();
  for (int i = 1; i < temp3Numbers.length; i++) {
    temp3Numbers[i - 1] = temp3Numbers[i];
  }

  temp3Numbers[temp3Numbers.length - 1] = messages[2]; //set value
  popStyle();
  
  //temp 4
  fill(19, 34, 44);
  rect(356, 17, 298, 150); // temp 4 box
  fill(11, 22, 30);
  rect(356, 17, 298, 40); // temp 4 title box
  fill(255, 255, 255);
  textFont(f1);
  textSize(20);
  text("TEMPERATURA 4", 420, 45); // temp 4 text
  textSize(10);
  text("800", 370, 76.6);
  text("600", 370, 93.2);
  text("400", 370, 109.8);
  text("200", 370, 126.4);
  pushStyle();
  stroke(255,255,255);      //set the stroke (line) color to white
  strokeWeight(2);      
  line(402,73.6,408,73.6);     //mini - lines  
  line(402,90.2,408,90.2);     //mini - lines  
  line(402,106.8,408,106.8);     //mini - lines
  line(402,123.4,408,123.4);     //mini - lines
  popStyle();

  // temp4 line graph
  pushStyle();
  stroke(255, 255, 255); // set the stroke (line) color to black
  strokeWeight(2); // set the stroke width (weight) for the axes
  line(356, 140, 654, 140); // draw the x-axis line
  line(406, 17, 406, 167); // draw the y-axis line
  noFill();
  stroke(0, 255, 255); // sets line color

  beginShape();
  for (int i = 0; i < temp4Numbers.length; i++) {
    float x = map(i, 0, temp4Numbers.length - 1, 356, 654);
    float y = map(temp4Numbers[i], 0, 1000, 140, 57);
    vertex(x, y);
  }
  endShape();
  for (int i = 1; i < temp4Numbers.length; i++) {
    temp4Numbers[i - 1] = temp4Numbers[i];
  }
  temp4Numbers[temp4Numbers.length - 1] = messages[3]; //set value
  popStyle();
  
  //conexalab logo
  fill(19,34,44);
  rect(685,17,298,150);      //conexalab logo box
  image(conexalab_img, 685, 17, 298, 150);      //image logo
  
  //dreamer rocket
  fill(19,34,44);
  rect(32,197,146,380);      //dreamer rocket box
  image(dreamer_img, 32,197,146,380);      //image logo
  
  //fuerza
  fill(19,34,44);
  rect(208,197,446,260);      //fuerza box
  fill(11,22,30);
  rect(208,197,446,40);      //fuerza title box
  fill(255,255,255);
  textFont(f1);
  textSize(20);
  text("FUERZA", 390, 225);      //fuerza text
  textSize(10);
  text("500", 226, 270.5);
  text("300", 226, 331.5);
  text("100", 226, 392.5);
  pushStyle();
  stroke(255,255,255);      //set the stroke (line) color to white
  strokeWeight(2);      
  line(256,267.5,260,267.5);     //mini - lines  
  line(256,328.5,260,328.5);     //mini - lines  
  line(256,389.5,260,389.5);     //mini - lines
  popStyle();
  
  //fuerza line graph
  pushStyle();
  stroke(255, 255, 255); // set the stroke (line) color to black
  strokeWeight(2); // set the stroke width (weight) for the axes
  line(208, 420, 654, 420); // draw the x-axis line
  line(258, 237, 258, 457); // draw the y-axis line
  noFill();
  stroke(0, 255, 255); // sets line color

  beginShape();
  for (int i = 0; i < fuerzaNumbers.length; i++) {
    float x = map(i, 0, fuerzaNumbers.length - 1, 208, 654);
    float y = map(fuerzaNumbers[i], 0, 600, 420, 237);
    vertex(x, y);
  }
  endShape();
  for (int i = 1; i < fuerzaNumbers.length; i++) {
    fuerzaNumbers[i - 1] = fuerzaNumbers[i];
  }
  fuerzaNumbers[fuerzaNumbers.length - 1] = messages[4]; // set value
  popStyle();
  
  //mamus logo
  fill(19,34,44);
  rect(208,487,446,90);      //mamus logo box
  image(mamus_img, 208,487,446,90);       //image logo
  
  //GP10
  fill(19,34,44);
  rect(685,197,110,130);      //gp10 box
  fill(11,22,30);
  rect(685,197,110,40);      //gp10 title box
  fill(255,255,255);
  textFont(f1);
  textSize(20);
  text("GP10", 715, 225);      //gp10 title
  //S1 and S2
  fill(255,255,255);
  textFont(f1);
  textSize(18);
  text("S1", 705, 267);      //s1 title
  fill(255,255,255);
  textFont(f1);
  textSize(18);
  text("S2", 705, 307);      //s2 title
  fill(111,57,0);
  circle(755, 260,25);      //s1 circle
  fill(111,57,0);
  circle(755,300,25);      //s2 circle
  s1Off = messages[5];  //set value
  if (s1Off == 1) {      //sets S1 ON
    fill(255, 115, 42);
    circle(755,260,25);
  } 
  s2Off = messages[6];  //set value
  if (s2Off == 1) {      //sets S2 ON
    fill(255, 115, 42);
    circle(755,300,25);
  } 
  
  //bateria
  fill(19,34,44);
  rect(825,197,158,130);      //bateria box
  fill(11,22,30);
  rect(825,197,158,40);      //bateria title box
  fill(255,255,255);
  textFont(f1);
  textSize(20);
  text("BATERIA", 865, 225);      //bateria title
  batteryKnob.setValue(messages[7]);  //set value
  if (batteryKnob.getValue()>65) {      //changes color to green if >65
    batteryKnob.setColorForeground(color(78,218,30));
    batteryKnob.setColorActive(color(78,218,30));
  } else if (batteryKnob.getValue()>30){      //changes color to yellow if >30
    batteryKnob.setColorForeground(color(255,245,59));
    batteryKnob.setColorActive(color(255,245,59));
  } else {      //changes color to red if <30
    batteryKnob.setColorForeground(color(216,34,34));
    batteryKnob.setColorActive(color(216,34,34));
  }
  
  //launcher
  fill(19,34,44);
  rect(685,357,298,100);      //launcher box
  fill(11,22,30);
  rect(685,357,298,40);      //launcher title box
  fill(255,255,255);
  textFont(f1);
  textSize(20);
  text("LAUNCHER", 780, 385);      //launcher text
  fill(255,255,255);
  textFont(f1);
  textSize(40);
  text(launcherState, launcherXcoordinate, launcherYcoordinate);      //launcher off text
  launcherOff = messages[8];  //set value
  if (launcherOff == 1) {      //launcher ACTIVATED
    launcherState = "ACTIVATED";
    launcherXcoordinate = 720;
  } else {
    launcherState = "OFF";
    launcherXcoordinate = 790;      //establishes coordinates to shift and center text
    launcherYcoordinate = 440;
  }
  
  //date
  fill(19,34,44);
  rect(685,487,134,90);      //date box
  int day = day();   
  int month = month();  
  int year = year();   
  String date = String.valueOf(day) + "/" + String.valueOf(month) + "/" + String.valueOf(year);
  fill(255,255,255);
  textFont(f1);
  textSize(22);
  text(date, 690, 540);      //date text
  
  //time
  fill(19,34,44);
  rect(849,487,134,90);      //time box
  int hour = hour();   
  int minute = minute();  
  int second = second();   
  String time = String.valueOf(hour) + ":" + String.valueOf(minute) + ":" + String.valueOf(second);
  fill(255,255,255);
  textFont(f1);
  textSize(25);
  text(time, 865, 540);      //time text
  
  data.flush(); // Writes the remaining data to the file
  //data.close(); // Finishes the file
}
