shader_type canvas_item;
uniform vec4 tint : source_color = vec4(0.5,0.75,0.9,1.0);
uniform float clock = 0.0;
uniform bool sparkles_enabled = true;
void fragment() {
 vec2 p = UV;
 float density = 0.0;
 float sparkle = 0.0;
 // Two-pixel cells keep the accents crisp over the soft smoke.
 vec2 pixel = floor(UV * vec2(56.0,110.0) / 2.0);
 for (int i = 0; i < 3; i++) {
  float phase = fract(clock * 0.12 + float(i) / 3.0);
  float y = 0.88 - phase * 0.75;
  float x = 0.5 + sin(phase * 5.0 + float(i) * 2.1) * 0.18;
  vec2 d = (p - vec2(x,y)) / vec2(0.12 + phase * 0.12,0.15);
  density += exp(-dot(d,d)*2.0) * sin(phase * 3.14159);
  if (sparkles_enabled) {
   vec2 centre = floor(vec2(x,y) * vec2(56.0,110.0) / 2.0);
   vec2 distance = abs(pixel-centre);
   float core = step(max(distance.x,distance.y),0.49);
   float cross = max(step(distance.x,0.49)*step(distance.y,1.49),step(distance.y,0.49)*step(distance.x,1.49));
   float blink = step(2.0,mod(floor(phase*12.0)+float(i)*2.0,4.0));
   float life = min(sin(phase*3.14159)*1.4,1.0);
   sparkle = max(sparkle,(core+(cross-core)*0.35)*blink*life*0.9);
  }
 }
 float smoke_alpha = min(density * 0.65,0.65) * tint.a;
 float spark_alpha = sparkle * tint.a;
 vec3 neon = tint.rgb / max(max(tint.r,tint.g),max(tint.b,0.001));
 neon = mix(neon,vec3(1.0),0.2);
 float alpha = spark_alpha + smoke_alpha*(1.0-spark_alpha);
 vec3 colour = (neon*spark_alpha+tint.rgb*smoke_alpha*(1.0-spark_alpha))/max(alpha,0.0001);
 COLOR = vec4(colour,alpha);
}
