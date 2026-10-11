extends Control
## Readable anticipation marks stay outside the actor's silhouette and below the title.
var presentation: Control
const LABELS = {"light":"SLASH", "heavy":"HEAVY STRIKE", "charge":"CHARGE", "bow":"DRAWING BOW", "spell":"CHANNELING", "heal":"RESTORING", "guard":"BRACING", "object":"INTERACTING"}
const COLORS = {"bow":Color("#D9BE83"),"spell":Color("#BD9FD7"),"heal":Color("#A5C38C"),"guard":Color("#A9BDD4")}

func _ready() -> void:
 name = "AttackTell"
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 z_index = 3
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _process(_delta: float) -> void: queue_redraw()

func _draw() -> void:
 if not is_instance_valid(presentation) or presentation.active.is_empty(): return
 var entry: Dictionary = presentation.active
 var frame: Dictionary = presentation.animation_sample()
 if frame["phase"] != "windup": return
 var profile: String = str(entry.get("profile","legacy"))
 if profile == "legacy": return
 var tint: Color = COLORS.get(profile,Color("#D69A88"))
 var caption: String = LABELS.get(profile,"PREPARING")
 caption = ("BOSS · " if entry.get("source_boss",false) else "") + caption
 var font: Font = ThemeDB.fallback_font
 var width: float = font.get_string_size(caption,HORIZONTAL_ALIGNMENT_LEFT,-1,17).x
 var area := Rect2(960-width*0.5-16,137,width+32,30)
 draw_rect(area,Color(0.035,0.024,0.035,0.94))
 draw_line(area.position+Vector2(0,29),area.position+Vector2(area.size.x*float(frame["windup"]),29),tint,2)
 draw_string(font,area.position+Vector2(16,21),caption,HORIZONTAL_ALIGNMENT_LEFT,-1,17,tint)
 # Short radiating ink strokes emphasize preparation without covering the body.
 if presentation.fighters.is_empty(): return
 var fighter: TextureRect = presentation.fighters[0]
 var origin: Vector2 = fighter.position+Vector2(fighter.size.x*0.5,-9)
 origin.y = maxf(origin.y,185)
 for index in range(3):
  var angle: float = -PI*0.5+(index-1)*0.5
  var direction := Vector2(cos(angle),sin(angle))
  draw_line(origin+direction*12,origin+direction*(18+float(frame["windup"])*12),tint,2,true)
