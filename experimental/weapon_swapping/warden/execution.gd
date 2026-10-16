extends "res://scenes/combat/warden_execution.gd"
## Experimental source frames only; victim, camera and prop timing use the live renderer.
const Visuals = preload("res://scripts/weapon_visuals.gd")
var weapon_id: String = "warden_sword"
var attacker_frames: Array[Texture2D] = []
var pair_frame: Texture2D
func _ready() -> void:
 super._ready()
 for index in range(5):
  var texture: Texture2D = Visuals._frame_for_weapon("warden","original","execution_"+str(index),weapon_id)
  assert(texture != null)
  attacker_frames.append(texture)
 pair_frame = Visuals._frame_for_weapon("warden","original","execution_contact",weapon_id)
 assert(pair_frame != null)
func _draw() -> void:
 if attacker_frames.is_empty() or pair_frame == null: return
 var layout: Dictionary = frame_layout(age,animate)
 var shake: float = sin((age-FINAL_HIT)*110)*4*(1-smoothstep(FINAL_HIT,1.1,age)) if animate and age >= FINAL_HIT and age < 1.1 else 0.0
 if age >= 0.42 and age < FINAL_HIT+0.13:
  var transform: Transform2D = layout.weapon_transform
  draw_set_transform(transform.origin,transform.get_rotation(),transform.get_scale())
  draw_texture(dropped_weapon,Vector2.ZERO)
  draw_set_transform(Vector2.ZERO)
 if layout.paired:
  var factor: float = layout.pair.size.x/contact.get_width()
  var floor_point: Vector2 = layout.pair.position+CONTACT_SOLES*factor+Vector2(shake,0)
  var rect := Rect2(floor_point-pair_frame.get_meta("foot_anchor")*factor,pair_frame.get_size()*factor)
  draw_texture_rect(pair_frame,rect,false)
 else:
  var target_rect: Rect2 = layout.target
  if layout.target_index < 3: target_rect.position.x += shake
  draw_texture_rect(targets[layout.target_index],target_rect,false)
  var source: int = layout.source_index
  var factor: float = layout.body.size.y/bodies[source].get_height()
  var sole: Vector2 = bodies[source].get_size()*Vector2(0.5,1.0)
  if source == 2: sole = WINDUP_SOLES
  if source == 3: sole = FOLLOW_SOLES
  if source == 4: sole = RECOVERY_SOLES
  var floor_point: Vector2 = layout.body.position+sole*factor
  var texture: Texture2D = attacker_frames[source]
  draw_texture_rect(texture,Rect2(floor_point-texture.get_meta("foot_anchor")*factor,texture.get_size()*factor),false)
 gore()
func pool() -> void:
 for index in range(6):
  draw_set_transform(Vector2(510+index*13,390+(index%2)*3),0,Vector2(23-index*2,4+index%3))
  draw_circle(Vector2.ZERO,1,Color("#4a0b14"))
 draw_set_transform(Vector2.ZERO)
