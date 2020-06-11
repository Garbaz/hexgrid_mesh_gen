PShape generate_hex_grid(float scale, float resolution, float gap_scale) {
  PShape hg = createShape();
  hg.beginShape(TRIANGLE);
  hg.noStroke();
  float s = scale/(2*resolution*gap_scale*sqrt(0.75) + sqrt(0.75));
  PVector v_unit = new PVector(-sqrt(0.75), 1.5);
  PVector u_unit = new PVector(2*sqrt(0.75), 0);
  v_unit.mult(gap_scale);
  u_unit.mult(gap_scale);
  __generate_hex_grid_sub_add_hex(hg, s, 0, 0);
  for (int a = 0; a < 6; a++) {
    for (int v = 0; v <= resolution; v++) {
      for (int u = 0; u < v; u++) {
        //Local slice coordinates
        float xl = v*v_unit.x + u*u_unit.x;
        float yl = v*v_unit.y + u*u_unit.y;

        //Rotating to current slice
        float x = cos(a*THIRD_PI)*xl+sin(a*THIRD_PI)*yl;
        float y = sin(a*THIRD_PI)*xl-cos(a*THIRD_PI)*yl;
        __generate_hex_grid_sub_add_hex(hg, s, x, y);
      }
    }
  }
  hg.endShape();
  return hg;
}

void __generate_hex_grid_sub_add_hex(PShape ps, float s, float x, float y) {
  for (int i = 0; i < 6; i++) {
    float ii = 0.5+i;
    ps.vertex(s*x, 0, s*y);
    ps.vertex(s*(x+cos(ii*THIRD_PI)), 0, s*(y+sin(ii*THIRD_PI)));
    ps.vertex(s*(x+cos((ii+1)*THIRD_PI)), 0, s*(y+sin((ii+1)*THIRD_PI)));
  }
}






//TODO: Instead of slice wise, do line by line
PShape generate_hex_grid_new(int resolution, float gap_scale) {

  PShape hg = createShape();
  hg.beginShape(TRIANGLE);
  hg.noStroke();
  float s = 1.0/(2*resolution*gap_scale*sqrt(0.75) + sqrt(0.75));
  PVector u_unit = new PVector(2*sqrt(0.75), 0);
  PVector v_unit = new PVector(sqrt(0.75), 1.5);
  v_unit.mult(gap_scale);
  u_unit.mult(gap_scale);
  for (int v = 0; v <= resolution; v++) {
    for (int u = 2*resolution-v; u >= 0; u--) {
      float x = v*v_unit.x + u*u_unit.x;
      float y = v*v_unit.y + u*u_unit.y;

      for (int i = 0; i < 6; i++) {
        float ii = 0.5+i;
        hg.vertex(s*x, 0, s*y);
        hg.vertex(s*(x+cos(ii*THIRD_PI)), 0, s*(y+sin(ii*THIRD_PI)));
        hg.vertex(s*(x+cos((ii+1)*THIRD_PI)), 0, s*(y+sin((ii+1)*THIRD_PI)));
      }
    }
  }

  return hg;
}
