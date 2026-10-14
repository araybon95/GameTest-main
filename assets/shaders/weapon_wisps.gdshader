shader_type canvas_item;
uniform vec4 tint : source_color = vec4(0.5,0.75,0.9,1.0);
uniform float clock = 0.0;
void fragment() {
 vec2 p = UV;
 float density = 0.0;
 for (int i = 0; i < 3; i++) {
  float phase = fract(clock * 0.12 + float(i) / 3.0);
  float y = 0.88 - phase * 0.75;
  float x = 0.5 + sin(phase * 5.0 + float(i) * 2.1) * 0.18;
  vec2 d = (p - vec2(x,y)) / vec2(0.12 + phase * 0.12,0.15);
  density += exp(-dot(d,d)*2.0) * sin(phase * 3.14159);
 }
 COLOR = vec4(tint.rgb, min(density * 0.65,0.65) * tint.a);
}
