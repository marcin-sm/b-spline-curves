int pts = 0; //number of points
int grade = 3; //degree of curve
boolean bare_curve=false; //storing information about the currently displayed mode

float area= 3*width; // random range adjusted to the window dimensions

//initialization of main global arrays storing points
float[] x = new float[pts];
float[] y = new float[pts];
float[] z = new float[pts];

//declaration of three-dimensional graphics and background parameters
void setup(){
  fullScreen(P3D);
  //size(1920,1080, P3D);
  noFill ();
  background(0); 
  smooth(10);
};


void draw(){
  if (bare_curve==false) //mode I 
  {translate (width/2, height/2);
  
  rotateY(frameCount / 100.0);
  stroke(255);
  drawCurve();
  stroke(255);
  noFill();
  strokeWeight(2);
  box (height/1.8);
  }
  if(bare_curve==true) //mode II 
  {
    
    clear();
    scale(1.5);
    translate (width/3, height/3);
    
    //smooth conversion of mouse linear displacements to angular displacements of a 3D object
    rotateX(radians(mouseY)); 
    rotateY(radians(mouseX));
    
  
    smooth();
    BSpline(); // function call without control polygon and guides
    
    if (mouseButton == LEFT)
      {
        x = null;
        y = null;
        z = null;
        pts = 0;
        x = new float[pts];
        y = new float[pts];
        z = new float[pts];
        bare_curve=false;
        
      }
  }
   
};

void drawCurve(){
  
  background(0);
  noFill();
 
 //main points
  for(int i=0; i<pts; i++){
    smooth();
    fill(255,0,0);
    strokeWeight(6);
    point(x[i],y[i],z[i]);
  };
  
  //help lines
  for (int i=0; i<pts-1; i++){
    stroke(255);
    strokeWeight(1);
    line(x[i],y[i], z[i], x[i+1], y[i+1], z[i+1]);
  };
  
  if(grade==3) 
  {
    if(pts==4) 
    {
      noFill();
      strokeWeight(2);
      stroke(255, 125,0); //main curve color
      bezier(x[0],y[0], z[0], x[1],y[1], z[1], x[2],y[2], z[2], x[3],y[3], z[3]);
    }
    
    else if(pts>4){ 
    
    //auxiliary arrays
    int pom = (pts - 4)*3 + 4;
    float[] xpom = new float[pom];
    float[] ypom = new float[pom];
    float[] zpom = new float[pom];
      xpom[0]=x[0];
      ypom[0]=y[0];
      zpom[0]=z[0];
      xpom[1]=x[1];
      ypom[1]=y[1];
      zpom[1]=z[1];
      xpom[pom-1]=x[pts-1];
      ypom[pom-1]=y[pts-1];
      zpom[pom-1]=z[pts-1];
      xpom[pom-2]=x[pts-2];
      ypom[pom-2]=y[pts-2];
      zpom[pom-2]=z[pts-2];
      xpom[2]=(x[1]+x[2])/2;
      ypom[2]=(y[1]+y[2])/2;
      zpom[2]=(z[1]+z[2])/2;
      xpom[pom-3]=(x[pts-3]+x[pts-2])/2;
      ypom[pom-3]=(y[pts-3]+y[pts-2])/2;
      zpom[pom-3]=(z[pts-3]+z[pts-2])/2;
      for (int i=3; i<pts-2; i++){
      int k=3*i-5; //<>//
      xpom[k]=x[i-1]+(x[i]-x[i-1])/3;
      ypom[k]=y[i-1]+(y[i]-y[i-1])/3;
      zpom[k]=z[i-1]+(z[i]-z[i-1])/3;
      xpom[k+1]=x[i-1]+2*(x[i]-x[i-1])/3;
      ypom[k+1]=y[i-1]+2*(y[i]-y[i-1])/3;
      zpom[k+1]=z[i-1]+2*(z[i]-z[i-1])/3;
      xpom[k-1]=(xpom[k-2]+xpom[k])/2;
      ypom[k-1]=(ypom[k-2]+ypom[k])/2;
      zpom[k-1]=(zpom[k-2]+zpom[k])/2;
      };
      xpom[pom-4]=(xpom[pom-5]+xpom[pom-3])/2;
      ypom[pom-4]=(ypom[pom-5]+ypom[pom-3])/2;
      zpom[pom-4]=(zpom[pom-5]+zpom[pom-3])/2;
      
      //algorithm for inserting auxiliary points
      for (int i=0; i<pom; i++)
      { int k = i % 3;
        smooth();
        if(i!=0 && i!=pom-1 && k == 0) { fill(0,0,255);} else {
        stroke(0,255,0); } //green helper points
        strokeWeight(4);
        point(xpom[i],ypom[i],zpom[i]);
      };
      
      //algorithm for plotting an auxiliary line
      for(int i=2; i<pom-2; i=i+3){
        stroke(255); //biała linia pomocnicza
        strokeWeight(1);
        line(xpom[i],ypom[i],zpom[i],xpom[i+1],ypom[i+1],zpom[i+1]);
        line(xpom[i+1],ypom[i+1],zpom[i+1],xpom[i+2],ypom[i+2],zpom[i+2]);
        
      };
      
      //algorithm for plotting a curve using Bezier
      for(int i=0; i<pom-1; i=i+3){
        noFill();
        strokeWeight(2);
        stroke(255,125,0); //kolor głównej krzywej
        bezier(xpom[i],ypom[i],zpom[i],xpom[i+1],ypom[i+1],zpom[i+1],xpom[i+2],ypom[i+2],zpom[i+2],xpom[i+3],ypom[i+3],zpom[i+3]);
      }
    }
  }
};


void mousePressed(){
  if(mouseButton == LEFT){
    if(bare_curve==false){
  pts++;
  
 
  float[]x2 = new float [x.length+1];
  for(int i=0; i<x.length; i++){
    x2[i]=x[i];
  };
  x=x2;
  
  float[]y2 = new float [y.length+1];
  for(int i=0; i<y.length; i++){
    y2[i]=y[i];
  };
  y=y2;
  
  float[]z2 = new float [z.length+1];
  for(int i=0; i<z.length; i++){
    z2[i]=z[i];
  };
  z=z2;
 
  // randomly defining points in the cube space
x[pts-1] = random (-area, area);
y[pts-1] = random (-area, area);
z[pts-1] = random (-area, area);

    }
    
  }
  else if(mouseButton == RIGHT){
    if(bare_curve == true) {bare_curve = false;}
    else {bare_curve = true; redraw();} 
  };
};

// analogous algorithm to drawCurve () without auxiliary elements
void BSpline(){
  
  background(0);
  noFill();
 
  
  if(grade==3)
  {
    if(pts==4)
    {
      noFill();
      strokeWeight(2);
      stroke(255);
      bezier(x[0],y[0], z[0], x[1],y[1], z[1], x[2],y[2], z[2], x[3],y[3], z[3]);
    }
    
    else if(pts>4){  
    int pom = (pts - 4)*3 + 4;
    float[] xpom = new float[pom];
    float[] ypom = new float[pom];
    float[] zpom = new float[pom];
      xpom[0]=x[0];
      ypom[0]=y[0];
      zpom[0]=z[0];
      xpom[1]=x[1];
      ypom[1]=y[1];
      zpom[1]=z[1];
      xpom[pom-1]=x[pts-1];
      ypom[pom-1]=y[pts-1];
      zpom[pom-1]=z[pts-1];
      xpom[pom-2]=x[pts-2];
      ypom[pom-2]=y[pts-2];
      zpom[pom-2]=z[pts-2];
      xpom[2]=(x[1]+x[2])/2;
      ypom[2]=(y[1]+y[2])/2;
      zpom[2]=(z[1]+z[2])/2;
      xpom[pom-3]=(x[pts-3]+x[pts-2])/2;
      ypom[pom-3]=(y[pts-3]+y[pts-2])/2;
      zpom[pom-3]=(z[pts-3]+z[pts-2])/2;
      for (int i=3; i<pts-2; i++){
      int k=3*i-5;
      xpom[k]=x[i-1]+(x[i]-x[i-1])/3;
      ypom[k]=y[i-1]+(y[i]-y[i-1])/3;
      zpom[k]=z[i-1]+(z[i]-z[i-1])/3;
      xpom[k+1]=x[i-1]+2*(x[i]-x[i-1])/3;
      ypom[k+1]=y[i-1]+2*(y[i]-y[i-1])/3;
      zpom[k+1]=z[i-1]+2*(z[i]-z[i-1])/3;
      xpom[k-1]=(xpom[k-2]+xpom[k])/2;
      ypom[k-1]=(ypom[k-2]+ypom[k])/2;
      zpom[k-1]=(zpom[k-2]+zpom[k])/2;
      };
      xpom[pom-4]=(xpom[pom-5]+xpom[pom-3])/2;
      ypom[pom-4]=(ypom[pom-5]+ypom[pom-3])/2;
      zpom[pom-4]=(zpom[pom-5]+zpom[pom-3])/2;
      
      
      for(int i=0; i<pom-1; i=i+3){
        noFill();
        strokeWeight(2);
        stroke(255);
        bezier(xpom[i],ypom[i],zpom[i],xpom[i+1],ypom[i+1],zpom[i+1],xpom[i+2],ypom[i+2],zpom[i+2],xpom[i+3],ypom[i+3],zpom[i+3]);
      }
    }
  }
};