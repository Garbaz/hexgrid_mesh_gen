
final int GRID_RESOLUTION = 5;
final float GRID_GAP_SCALE = 1.1;
PShape hexgrid;

void setup() {
  size(800, 800, P3D);

  //perspective(radians(78), width/height, 0.01, 1000);

  hexgrid = createShape();


  hexgrid.beginShape(TRIANGLE);
  float s = 1.0/(2*GRID_RESOLUTION*GRID_GAP_SCALE*sqrt(0.75) + sqrt(0.75));
  PVector v_unit = new PVector(-sqrt(0.75), 1.5);
  PVector u_unit = new PVector(2*sqrt(0.75), 0);
  v_unit.mult(GRID_GAP_SCALE);
  u_unit.mult(GRID_GAP_SCALE);
  for (int a = 0; a < 6; a++) {
    for (int v = 0; v <= GRID_RESOLUTION; v++) {
      for (int u = 0; u <= v; u++) {
        //Local slice coordinates
        float xl = v*v_unit.x + u*u_unit.x;
        float yl = v*v_unit.y + u*u_unit.y;
        
        //Rotating to current slice
        float x = cos(a*THIRD_PI)*xl+sin(a*THIRD_PI)*yl;
        float y = sin(a*THIRD_PI)*xl-cos(a*THIRD_PI)*yl;

        for (int i = 0; i < 6; i++) {
          float ii = 0.5+i;

          hexgrid.vertex(s*x, 0, s*y);
          hexgrid.vertex(s*(x+cos(ii*THIRD_PI)), 0, s*(y+sin(ii*THIRD_PI)));
          hexgrid.vertex(s*(x+cos((ii+1)*THIRD_PI)), 0, s*(y+sin((ii+1)*THIRD_PI)));
        }
      }
    }
  }
  hexgrid.endShape();
}

void draw() {
  background(#C4FFFE);
  //camera(0, 2.05, -0.01, 0, 0, 0, 0, -1, 0);
  translate(width/2,height/2);
  scale(width/2);
  rotateX(PI/2);
  shape(hexgrid);
}





//float s = 0.5/GRID_RES;
//float sy = 0.1+sqrt(0.75);
//float sx = 0.2+3;
//hexgrid.beginShape(TRIANGLE);
//for (int yi = -GRID_RES; yi < GRID_RES; yi++) {
//  for (int xi = -GRID_RES/4; xi < GRID_RES/4; xi++) {
//    for (int i = 0; i < 6; i++) {
//      float x = sx*(xi+0.5*((yi+GRID_RES)%2));
//      float y = sy*yi;
//      hexgrid.vertex(s*x, 0, s*y);
//      hexgrid.vertex(s*(x+cos(i*THIRD_PI)), 0, s*(y+sin(i*THIRD_PI)));
//      hexgrid.vertex(s*(x+cos((i+1)*THIRD_PI)), 0, s*(y+sin((i+1)*THIRD_PI)));
//    }
//  }
//}

//float s = 0.5/GRID_RES;
//float sr1 = 2*sqrt(0.75);
//float sr2 = 1.5;

//hexgrid.beginShape(TRIANGLE);
//for (int r = 0; r < GRID_RES; r++) {
//  for (int a = 0; a < 6*r; a++) {
//    float sa = THIRD_PI/r;
//    float sr = ((a%r)*sr2 + (r-(a%r))*sr1)/r;//(a%r==0 ? sr1 : sr2);
//    sr = sr1;
//    float x = sr*r*cos(sa*a);
//    float y = sr*r*sin(sa*a);
//    for (int i = 0; i < 6; i++) {
//      float ii = 0.5+i;

//        hexgrid.vertex(s*x, 0, s*y);
//      hexgrid.vertex(s*(x+cos(ii*THIRD_PI)), 0, s*(y+sin(ii*THIRD_PI)));
//      hexgrid.vertex(s*(x+cos((ii+1)*THIRD_PI)), 0, s*(y+sin((ii+1)*THIRD_PI)));
//    }
//  }
//}
