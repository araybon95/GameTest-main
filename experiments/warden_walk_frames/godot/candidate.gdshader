shader_type canvas_item;
uniform sampler2D atlas : filter_linear, repeat_disable;
uniform sampler2D tweens : filter_linear, repeat_disable;
uniform vec4 region;
uniform vec4 tween_region;
uniform vec2 frame_size;
uniform vec2 tween_size;
uniform vec2 tween_origin;
uniform vec2 canvas_size;
uniform vec2 root_point;
uniform bool improved = false;
uniform vec2 near_mask[32];
uniform vec2 far_mask[32];
uniform vec2 path_mask[32];
uniform vec2 gear_mask[32];
uniform vec2 shaft_mask[32];
uniform int near_count;
uniform int far_count;
uniform int path_count;
uniform int gear_count;
uniform int shaft_count;
bool inside(vec2 p, vec2 polygon[32], int count) {
 bool hit=false;
 for (int i=0;i<32;i++) {
  if (i>=count) break;
  int j=(i+1)%count;
  vec2 a=polygon[i],b=polygon[j];
  if ((a.y>p.y)!=(b.y>p.y) && p.x<(b.x-a.x)*(p.y-a.y)/(b.y-a.y)+a.x) hit=!hit;
 }
 return hit;
}
void fragment() {
 vec2 p=UV*canvas_size-root_point;
 vec2 uv=(p+vec2(frame_size.x*0.5,280.0))/frame_size;
 vec4 original=texture(atlas,region.xy+clamp(uv,vec2(0),vec2(1))*region.zw);
 if (uv.x<0.0 || uv.x>1.0 || uv.y<0.0 || uv.y>1.0) original=vec4(0);
 vec4 result=original;
 if (improved) {
  vec2 next_uv=(p-tween_origin)/tween_size;
  vec4 next=texture(tweens,tween_region.xy+clamp(next_uv,vec2(0),vec2(1))*tween_region.zw);
  if (next_uv.x<0.0 || next_uv.x>1.0 || next_uv.y<0.0 || next_uv.y>1.0) next=vec4(0);
  bool gear=inside(p,gear_mask,gear_count) || inside(p,shaft_mask,shaft_count);
  bool original_leg=inside(p,near_mask,near_count) || inside(p,far_mask,far_count);
  // The cleaned sheet has no lower weapon. Replace the whole leg overlap,
  // including cloth, while retaining only the precise original gear masks.
  // Keep the hip plates intact, joining the cleaned thigh over a short band.
  // Only grow the silhouette below the knee area, away from shield fringes.
  if (!gear && original_leg) result=mix(original,next,smoothstep(-115.0,-100.0,p.y));
  else if (!gear && p.y>-70.0 && original.a<0.08 && inside(p,path_mask,path_count)) result=next;
 }
 COLOR=result;
}
