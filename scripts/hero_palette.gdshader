shader_type canvas_item;
uniform vec4 accent : source_color = vec4(0.2, 0.7, 0.35, 1.0);
uniform int source_family = 0;
uniform bool recolor = true;
uniform vec3 ambient = vec3(1.0);
uniform float firelight = 0.0;
varying vec4 modulation;
void vertex() { modulation = COLOR; }
void fragment() {
	vec4 original = texture(TEXTURE, UV);
	float largest = max(original.r, max(original.g, original.b));
	float smallest = min(original.r, min(original.g, original.b));
	float saturation = (largest - smallest) / max(largest, 0.001);
	bool match_color = source_family == 0 ? (original.r > original.g * 1.3 && original.r > original.b * 1.12) : source_family == 1 ? (original.g > original.r * 1.15 && original.g > original.b * 1.08) : (original.b > original.g * 1.25 && original.r > original.g * 1.15);
	float mask = match_color ? smoothstep(0.25, 0.65, saturation) : 0.0;
	vec3 replacement = accent.rgb * largest / max(max(accent.r, accent.g), accent.b);
	vec3 painted = mix(original.rgb, replacement, recolor ? mask : 0.0);
	painted *= ambient;
	painted += vec3(0.14,0.065,0.018) * firelight * (0.35+UV.y*0.65);
	COLOR = modulation * vec4(painted, original.a);
}
