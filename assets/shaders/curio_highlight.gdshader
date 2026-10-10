shader_type canvas_item;
uniform vec4 glow_color : source_color = vec4(0.9,0.7,0.3,1.0);
uniform float strength = 0.2;
varying vec4 modulation;
void vertex() { modulation = COLOR; }
void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	float edge = 0.0;
	for (int x = -2; x <= 2; x++) {
		for (int y = -2; y <= 2; y++) {
			edge = max(edge, texture(TEXTURE, UV + vec2(float(x),float(y))*TEXTURE_PIXEL_SIZE).a);
		}
	}
	vec4 source = pixel * modulation;
	float outline = max(edge-pixel.a,0.0)*strength;
	COLOR = vec4(mix(source.rgb,glow_color.rgb,outline), max(source.a,outline));
}
