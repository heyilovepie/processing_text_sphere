/* @pjs preload = "ball/data/texture.jpg"; */
import processing.opengl.*;

TextureSphere sphere;

void setup(){
  size(500, 500, OPENGL);
  PImage t = loadImage("ball/data/texture.jpg");
  noStroke();
  
  sphere = new TextureSphere(new PVector(0,0,0), new PVector(600, 600, 600), 30, 30, t);
}
void draw(){
  background(0);
  camera(width/2+map(mouseX, 0, width, -2*width, 2*width), height/2+map(mouseY, 0, height, -2*height, 2*height), height/2/tan(PI*30.0 / 180.0), 
  width/2.0, height/2.0, 0, 
  0, 1, 0);
  
  sphere.render();
}
