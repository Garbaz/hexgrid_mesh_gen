//Processing built-in
uniform mat4 transformMatrix;

attribute vec4 position;
attribute vec4 color;

varying vec4 vertColor;
//--

uniform sampler2D noise;

uniform float time;
uniform vec2 world_pos;

const vec3 SAND_COLOR =  vec3(0.8, 0.8, 0.65);
const vec3 GRASS_COLOR = vec3(0.1, 0.7, 0.1);
const vec3 STONE_COLOR = vec3(0.7, 0.7, 0.7);
const vec3 SNOW_COLOR =  vec3(0.9, 0.9, 0.9);

const float GRASS_HEIGHT = 0.2;
const float STONE_HEIGHT = 0.5;
const float SNOW_HEIGHT = 0.8;

const float HEIGHT_SMOOTHING = 0.05;

void main() {
    vec2 uv = 0.1*(world_pos+position.xz);
    float height = 2.5*texture(noise,fract(uv)).r-1.0;

    gl_Position = transformMatrix * vec4(position.xyz+vec3(0, height, 0), 1.0);

    vec3 col = mix(SAND_COLOR, GRASS_COLOR, smoothstep(GRASS_HEIGHT-HEIGHT_SMOOTHING, GRASS_HEIGHT, height));
    col = mix(col, STONE_COLOR, smoothstep(STONE_HEIGHT-HEIGHT_SMOOTHING, STONE_HEIGHT,height));
    col = mix(col, SNOW_COLOR, smoothstep(SNOW_HEIGHT-HEIGHT_SMOOTHING, SNOW_HEIGHT,height));
    vertColor = vec4(col, 1.0);
}