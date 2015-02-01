class TextureSphere {
  
  PVector pos;
  PVector radius;

  int numPointsW;
  int numPointsH_2pi; 
  int numPointsH;

  PImage t;

  float[] coorX;
  float[] coorY;
  float[] coorZ;
  float[] multXZ;

  TextureSphere(PVector pos, PVector radius, int numPointsW, int numPointsH_2pi, PImage t) {
    
    this.pos=pos;
    this.radius=radius;
    
    //the number of points around the width and height
    this.numPointsW=numPointsW;
    this.numPointsH_2pi=numPointsH_2pi; //how many actual pts around the sphere (not just from top to bottom)
    numPointsH=ceil((float)numPointsH_2pi/2)+1; //how many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)
    
    this.t=t;
    
    coorX=new float[numPointsW];
    coorY=new float[numPointsH]; 
    coorZ=new float[numPointsW];
    multXZ=new float[numPointsH]; //the radius of each circle (that you will multiply with coorX and coorZ)

    for (int i=0; i<numPointsW ;i++) { //for all the points around the width
      float thetaW=i*2*PI/(numPointsW-1);
      coorX[i]=sin(thetaW);
      coorZ[i]=cos(thetaW);
      }
    for (int i=0; i<numPointsH; i++) { //for all points from top to bottom
      if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) { //if the numPointsH_2pi is odd and it is at the last pt
        float thetaH=(i-1)*2*PI/(numPointsH_2pi);
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=0;
      } else {
        //the numPointsH_2pi and 2* below allows there to be a flat bottom if the numPointsH is odd
        float thetaH=i*2*PI/(numPointsH_2pi);  
        //PI+ below makes the top always the point instead of the bottom.
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=sin(thetaH);
      }
    }
  }
  void render(){
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    draw();
    popMatrix();
  }
  void draw() { 
  //these are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0; //width variable for the texture
  float v=0; //height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) { //for all the rings but top and bottom
  //goes into the array here instead of loop to save time
  float coory=coorY[i];
  float cooryPlus=coorY[i+1];
  
  float multxz=multXZ[i];
  float multxzPlus=multXZ[i+1];
  
    for (int j=0; j<numPointsW; j++) { //for all the pts in the ring
      normal(coorX[j]*multxz, coory, coorZ[j]*multxz);
      vertex(coorX[j]*multxz*radius.x, coory*radius.y, coorZ[j]*multxz*radius.z, u, v);
      normal(coorX[j]*multxzPlus, cooryPlus, coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*radius.x, cooryPlus*radius.y, coorZ[j]*multxzPlus*radius.z, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  endShape();
  }
}
