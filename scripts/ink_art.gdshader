shader_type canvas_item;
// A restrained ink-and-wash treatment applied to scenery, never UI text.
void fragment() {
 vec4 base = COLOR;
 vec3 c = base.rgb;
 float l = dot(c, vec3(0.299,0.587,0.114));
 float stepped = floor(l * 9.0 + 0.5) / 9.0;
 c *= mix(1.0, stepped / max(l,0.025), 0.28);
 c = mix(vec3(l), c, 0.82);
 c = (c - 0.5) * 1.08 + 0.5;
 float edge = length(UV - vec2(0.5)) * 1.35;
 c *= 1.0 - smoothstep(0.3,0.85,edge) * 0.23;
 COLOR = vec4(clamp(c,0.0,1.0),base.a);
}
