shader_type canvas_item;
void fragment() {
	float sides = pow(abs(UV.x * 2.0 - 1.0), 7.0);
	float roof = pow(1.0 - UV.y, 8.0);
	// Keep actors, the floor and all lower HUD text clear.
	COLOR = vec4(0.018, 0.012, 0.016, min(0.26, sides * 0.22 + roof * 0.16));
}
