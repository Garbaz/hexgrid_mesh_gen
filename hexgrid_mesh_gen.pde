import com.jogamp.newt.opengl.GLWindow;

GLWindow gl_window;

final float FLY_SPEED = 1;
final float INPUT_MOUSE_SENS = 2.0*radians(0.022);

final float MAP_SCALE = 3;
final int MAP_RESOLUTION = 32;
final float GRID_GAP_SCALE = 1.0;

PImage noise_tex;
PShape landscape, water;
PShader landscape_shader, water_shader;

PVector camera_pos = VEC(0, 1, 0);
PVector camera_dir = VEC(0, 0, 1);
float camera_orientation_vertical, camera_orientation_horizontal;

PVector map_pos = VEC(0, 0);

void settings() {
  //size(1600, 900, P3D);
  fullScreen(P3D);
}

void setup() {
  frameRate(144);
  gl_window = (GLWindow)getSurface().getNative();
  noCursor();
  perspective(radians(78), float(width)/height, 0.01, 1000);
  mouseX = width/2;
  mouseY = height/2;

  noise_tex = loadImage("noise.png");
  landscape_shader = loadShader("landscape_shader.frag", "landscape_shader.vert");
  landscape_shader.set("noise", noise_tex);
  water_shader = loadShader("water_shader.frag", "water_shader.vert");
  water_shader.set("noise", noise_tex);

  landscape = generate_hex_grid(MAP_SCALE, MAP_RESOLUTION, GRID_GAP_SCALE);
  water = generate_hex_grid(MAP_SCALE, MAP_RESOLUTION, 1.0);




  deltatime_lasttime = millis();
}

void draw() {
  float dt = deltatime();
  background(#C4FFFE);
  //camera(2.0*cos(millis()*0.001), 2.0, 2.0*sin(millis()*0.001), 0, 0, 0, 0, -1, 0);
  update_camera(dt);
  camera(camera_pos.x, camera_pos.y, camera_pos.z, camera_pos.x+camera_dir.x, camera_pos.y+camera_dir.y, camera_pos.z+camera_dir.z, 0, -1, 0);

  map_pos.set(floor(10*camera_pos.x)/10.0, floor(10*camera_pos.z)/10.0);

  update_shader_uniforms();



  translate(map_pos.x, 0, map_pos.y);

  shader(landscape_shader);
  shape(landscape);

  shader(water_shader);
  shape(water);
  resetShader();
}

void update_shader_uniforms() {
  landscape_shader.set("time", millis()/1000.0);
  water_shader.set("time", millis()/1000.0);
  landscape_shader.set("world_pos", map_pos.x, map_pos.y);
  water_shader.set("world_pos", map_pos.x, map_pos.y);
}

void update_camera(float dt) {
  if (focused) {
    float mouseDeltaX = mouseX - width/2;
    float mouseDeltaY = mouseY - height/2;
    gl_window.warpPointer(width/2, height/2);

    camera_orientation_horizontal += INPUT_MOUSE_SENS*mouseDeltaX;
    camera_orientation_vertical -= INPUT_MOUSE_SENS*mouseDeltaY;

    camera_orientation_horizontal = (camera_orientation_horizontal+TWO_PI) % TWO_PI;
    camera_orientation_vertical = constrain(camera_orientation_vertical, -0.99*HALF_PI, 0.99*HALF_PI);

    camera_dir.set(cos(camera_orientation_vertical) * sin(camera_orientation_horizontal), sin(camera_orientation_vertical), cos(camera_orientation_vertical) * cos(camera_orientation_horizontal));
  }

  if (mousePressed) {
    if (mouseButton == LEFT) {
      vec_add_scaled(camera_pos, camera_dir, FLY_SPEED*dt);
    } else {
      vec_add_scaled(camera_pos, camera_dir, -FLY_SPEED*dt);
    }
  }

  camera(camera_pos.x, camera_pos.y, camera_pos.z, camera_pos.x+camera_dir.x, camera_pos.y+camera_dir.y, camera_pos.z+camera_dir.z, 0, -1, 0);
}
