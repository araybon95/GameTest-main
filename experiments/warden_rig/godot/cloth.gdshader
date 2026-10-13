shader_type canvas_item;
uniform vec2 canvas_size = vec2(1247.0,1261.0);
uniform float clock = 0.0;
uniform float wind = 0.0;
varying vec4 ink;
void vertex() {
	ink = COLOR;
	vec2 n = VERTEX/max(canvas_size,vec2(1.0));
	float hem = smoothstep(0.19,0.86,n.y);
	VERTEX.x += sin(clock*1.6+n.y*4.0)*6.0*hem*wind;
	VERTEX.y += sin(clock*1.2+n.x*2.0)*1.3*hem*wind;
}
void fragment() { COLOR = texture(TEXTURE,UV)*ink; }
