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
  size(1366,768);
  //myPort = new Serial(this, "COM9", 9600);
  //myPort.bufferUntil('\n');
  
  font = createFont(PFont.list()[2],80);
  textFont(font);
  stroke(255);

  int radius = min(width, height) / 2;
  indicator = radius * 0.25;            // the bigger indicator
  indicator2 = radius;                  // the smaller long point indicator
  speedoDiameter = radius * 1.8;        // the actual speedometer size 
 
  // Load background Image
  backdropImage = loadImage("speed.png");

  // Co-ordinates of centre of indicator
  cx = 680;
  cy = 546;

}

void draw() {
  //The serialEvent controls the display
    background(0);
    imageMode(CENTER);
    image(backdropImage,width/2,height/2,width,height);
  // Draw the clock background
  noFill();
  noStroke();
  //ellipse(cx, cy, speedoDiameter, speedoDiameter);

//----------------------------------------------------------------------
  //i = 30;
  check();
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

  text("Speed", cx-120, cy+160);        // static display
  //text(sensorReading, cx-80, cy+160);    // Dynamic display

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
  
  println("" + parseInt(i));
}

void check()
{
  if (i<60)
  {i++;}
  else 
  {i =0;} 
}

