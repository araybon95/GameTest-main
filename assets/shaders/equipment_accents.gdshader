shader_type canvas_item;
#include "res://assets/shaders/actor_motion.gdshaderinc"
uniform vec4 accent : source_color = vec4(0.6,0.8,1.0,1.0);
uniform vec4 atlas_area = vec4(0.0,0.0,1.0,1.0);
uniform int pattern = 0;
uniform float strength = 0.7;
uniform float clock = 0.0;
uniform bool etched = false;
uniform bool armor = false;
void vertex() { VERTEX = animate_actor_vertex(VERTEX); }
void fragment() {
	vec4 sprite = texture(TEXTURE, UV);
	vec2 p = (UV - atlas_area.xy) / atlas_area.zw;
	float pulse = 0.7 + 0.3 * sin(clock * 1.7);
	float metal = smoothstep(0.18,0.45,min(sprite.r,min(sprite.g,sprite.b)));
	float edge = 1.0 - smoothstep(0.005,0.019,abs(fract(p.y * (armor ? 9.0 : 13.0) + p.x * 4.0) - 0.5));
	float speck = step(0.98,fract(sin(dot(floor(p*130.0),vec2(12.9898,78.233)))*43758.5453));
	float mask = edge * metal * 0.45;
	if (pattern == 1 || pattern == 2) mask = max(mask,speck * metal * pulse);
	if (pattern == 3) mask = edge * metal * 0.65;
	if (pattern == 4 || pattern == 5) mask = max(mask,speck * metal * 0.9);
	float trim = (1.0-smoothstep(0.005,0.016,abs(p.y-0.36))) * smoothstep(0.2,0.4,p.x) * (1.0-smoothstep(0.6,0.8,p.x));
	if (etched) mask = max(mask,trim*0.75);
	COLOR = vec4(accent.rgb,mask * sprite.a * strength * pulse);
}
