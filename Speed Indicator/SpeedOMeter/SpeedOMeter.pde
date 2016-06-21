// This is an interactive project to show speedometer functionality  
// it can be used with arduino or any other serial commuincation devices
// Created by Ajay Yadiki

import processing.serial.*;
Serial myPort;
String sensorReading="";
String message=""; 
PFont font;
float val;
float i,k,s;

int cx, cy;
float indicator;
float indicator2;
float speedoDiameter;

PImage backdropImage;

void setup() {
    
  // change this to fit in other displays like 1920x1080, 1280,720 etc. 
  // we also need to change the position of center of Indicator
  size(1366,768);
  
  // please check twice the COM Port and Baudrate before running program
  myPort = new Serial(this, "COM4", 115200);
  myPort.bufferUntil('\n');
  
  // choose the font style
  font = createFont(PFont.list()[2],80);
  textFont(font);
  stroke(255);

  // creating the actual indicator  
  int radius = min(width, height) / 2;
  indicator = radius * 0.25;            // the bigger background of indicator
  indicator2 = radius;                  // the smaller long point indicator
  speedoDiameter = radius * 1.8;        // the actual speedometer size 
 
  // Please keep the loading image in the same directory 
  // Load background Image initially so it gives better run-time performance
  backdropImage = loadImage("speed.png");

  // Co-ordinates of centre of indicator
  cx = 680;
  cy = 546;
  

}

void draw() {
  
    background(0);
    imageMode(CENTER);
    image(backdropImage,width/2,height/2,width,height);
    
  // Draw the clock background
  noFill();
  noStroke();
  //ellipse(cx, cy, speedoDiameter, speedoDiameter);

//------------------------------------------------------------------------
// this is very important step, the variable val contains values which are transmitted
// by arduino through serial commuication, generally the maximum value will be 1024
// so we have to derive the value of i so that it will be in range of 0 to 60 
// for example i = val/divident, divident = maximum_value/60, generally max value is 1024
// so the divident = 1024/60 = 17 >> i = val/17.
  i = val/17;
  //check();
//------------------------------------------------------------------------  
  if (i>=60)
  {
    k = 60;
    s = map(k, 0, 60, 0, TWO_PI) + TWO_PI;
  }
    else 
    {
      k = (i/2)+30;//--------------------------------formula for speed-o-meter
      s = map(k, 0, 60, 0, TWO_PI) + TWO_PI;
    }
  
  stroke(0,254,254);
  strokeWeight(8);
  line(cx, cy, cx + cos(s) * indicator2, cy + sin(s) * indicator2);

  stroke(0,0,0);
  strokeWeight(15);
  line(cx, cy, cx + cos(s) * indicator, cy + sin(s) * indicator);

  //text("Speed", cx-120, cy+160);        // Static display
  //text(sensorReading, cx-80, cy+160);   // Dynamic display of actual reading
  text(i,cx-120,cy+160);                  // Dynamic display of calibrated reading
  
  
  for (int a = 180; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * indicator;
    float y = cy + sin(angle) * indicator;
    vertex(x, y);
  }
  endShape();

}  

void serialEvent (Serial myPort){
 sensorReading = myPort.readStringUntil('\n');

  if(sensorReading != null){
    sensorReading=trim(sensorReading);
    val = float(sensorReading);
  }
}

// this is only for testing while sensor doesn't give any reading or hardware is not connected
//void check()
//{
//  if (i<60)
//  {i++;}
//  else 
//  {i =0;} 
//}

