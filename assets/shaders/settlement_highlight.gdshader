shader_type canvas_item;
varying vec4 modulation;
void vertex() { modulation = COLOR; }
void fragment() {
	vec4 painted = texture(TEXTURE,UV);
	COLOR = vec4(painted.rgb * 0.87 + vec3(0.018,0.010,0.003), painted.a) * modulation;
}
