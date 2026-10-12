shader_type canvas_item;
#include "res://stride.gdshaderinc"
varying vec4 modulation;
void vertex() { modulation = COLOR; VERTEX = deform_actor(VERTEX); }
void fragment() { COLOR = modulation*texture(TEXTURE,UV); }
