shader_type canvas_item;
uniform float gate_focus = 0.0;
uniform bool animate = true;
void fragment() {
 vec4 ink = texture(TEXTURE,UV);
 float doorway = 1.0-smoothstep(0.55,1.0,length((UV-vec2(0.80,0.48))/vec2(0.20,0.45)));
 float fire = (1.0-smoothstep(0.0,0.08,length(UV-vec2(0.685,0.43))))+(1.0-smoothstep(0.0,0.08,length(UV-vec2(0.91,0.43))));
 float flicker = animate ? 0.5+0.5*sin(TIME*3.1)*sin(TIME*5.7) : 0.5;
 ink.rgb *= 1.0+doorway*gate_focus*0.18;
 ink.rgb += vec3(0.07,0.025,0.006)*(fire*flicker+doorway*gate_focus*0.35);
 COLOR = ink;
}
