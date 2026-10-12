extends Control
## Input-transparent camera framing. Exploration keeps its existing movement and encounter rules.
var scene_theme: String = "bandit"

func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
 var accent: Color = {"bandit":Color("#A58662"),"keep":Color("#82909D"),"beast":Color("#A75E65"),"medical":Color("#809771")}.get(scene_theme,Color("#A58662"))
 # Soft top shade holds the title; the bottom blends scenery into the travel desk.
 for i in range(50):
  var fraction: float = float(i)/50.0
  draw_rect(Rect2(0,i*3.0,1920,3),Color(0.018,0.012,0.02,(1.0-fraction)*0.72))
  draw_rect(Rect2(0,600+i*3.0,1920,3),Color(0.018,0.012,0.02,fraction*0.94))
 draw_rect(Rect2(0,750,1920,330),Color("#0C090D"))
 draw_line(Vector2(35,759),Vector2(1885,759),accent.darkened(0.45),2,true)
 for x in [35.0,1108.0,1885.0]:
  draw_colored_polygon(PackedVector2Array([Vector2(x-5,759),Vector2(x,754),Vector2(x+5,759),Vector2(x,764)]),accent)
 # Irregular black edges keep the centre open for actors and landmarks.
 for side in [0,1]:
  var x: float = 0 if side == 0 else 1920
  var direction: float = 1 if side == 0 else -1
  draw_colored_polygon(PackedVector2Array([Vector2(x,0),Vector2(x+direction*38,0),Vector2(x+direction*22,105),Vector2(x+direction*44,225),Vector2(x+direction*17,390),Vector2(x+direction*32,590),Vector2(x+direction*55,750),Vector2(x,750)]),Color("#09070C"))
