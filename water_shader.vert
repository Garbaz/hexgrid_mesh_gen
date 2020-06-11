//Processing built-in
uniform mat4 transformMatrix;

attribute vec4 position;
attribute vec4 color;

varying vec4 vertColor;
//--

uniform sampler2D noise;

uniform float time;
uniform vec2 world_pos;

const vec4 WATER_COLOR = vec4(0.0, 0.2, 0.6, 0.5);

void main() {
    vec2 uv = 0.3*(world_pos+position.xz);

    float height = 0.1*texture(noise,fract(uv+time*vec2(-0.01, 0.09))).r;

    gl_Position = transformMatrix * vec4(position.xyz+vec3(0, height, 0), 1.0);

    vertColor = WATER_COLOR;
}