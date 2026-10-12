shader_type canvas_item;
#include "res://stride.gdshaderinc"
void vertex() { VERTEX = deform_actor(VERTEX); }
void fragment() { COLOR = vec4(0.95,0.65,0.25,0.35); }
