shader_type canvas_item;

uniform vec4 frame_uv = vec4(0.0, 0.0, 1.0, 1.0);
uniform float breath_pixels = 0.0;
varying vec4 sprite_tint;

void vertex() {
	sprite_tint = COLOR;
}

void fragment() {
	vec2 local_uv = (UV - frame_uv.xy) / frame_uv.zw;
	// A tiny lift above the belt, tapering to zero before the legs.
	// This preserves the armor's shape and keeps both feet planted.
	float upper_body = 1.0 - smoothstep(0.38, 0.67, local_uv.y);
	vec2 sample_uv = UV + vec2(0.0, breath_pixels * TEXTURE_PIXEL_SIZE.y * upper_body);
	vec2 bounds_min = frame_uv.xy + TEXTURE_PIXEL_SIZE * 0.5;
	vec2 bounds_max = frame_uv.xy + frame_uv.zw - TEXTURE_PIXEL_SIZE * 0.5;
	COLOR = sprite_tint * texture(TEXTURE, clamp(sample_uv, bounds_min, bounds_max));
}
