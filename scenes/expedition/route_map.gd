extends Control
## Large illustrated floor map. Hover/focus previews a route without spending RNG.
const State = preload("res://scripts/game_data.gd")
const Scenery = preload("res://scripts/dungeon_scenery.gd")
var preview_route: Array = []
var new_rooms: Array = []
var reveal_age: float = 0.0
var clock: float = 0.0
var tiles: Dictionary = {}
const COLORS = {"battle":"#C0746D","boss":"#DC9A64","camp":"#A5BB86","treasure":"#D7B974","event":"#B397BF","stairs":"#94BDC8","chamber":"#AB9987","entry":"#AB9987"}
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 for location in State.floors[State.floor_index]:
  var room: Dictionary = State.floors[State.floor_index][location]
  if not room.get("seen",false): continue
  tiles[location] = load(Scenery.stage_path(State.floor_background("camp" if room.kind == "camp" else "combat")))
func room_rect(location: Vector2i) -> Rect2:
 var rooms: Dictionary = State.floors[State.floor_index]
 var low := Vector2i(999,999)
 var high := Vector2i(-999,-999)
 for point in rooms:
  low = Vector2i(mini(low.x,point.x),mini(low.y,point.y))
  high = Vector2i(maxi(high.x,point.x),maxi(high.y,point.y))
 var span := Vector2(high-low+Vector2i.ONE)
 var cell := Vector2(size.x/span.x,size.y/span.y)
 var centre := (Vector2(location-low)+Vector2(0.5,0.5))*cell
 return Rect2(centre-Vector2(70,46),Vector2(140,92))
func _process(delta: float) -> void:
 var settings = get_node_or_null("/root/GameSettings")
 if settings == null or settings.ambient_motion: clock += delta
 reveal_age += delta
 queue_redraw()
func set_route(route: Array) -> void:
 preview_route = route.duplicate()
 queue_redraw()
func _draw() -> void:
 var rooms: Dictionary = State.floors[State.floor_index]
 var markers: Array = []
 var art = preload("res://scripts/route_map_art.gd")
 art.backing(self)
 for location in rooms:
  if not rooms[location].get("seen",false): continue
  for direction in [Vector2i.RIGHT,Vector2i.DOWN]:
   var next: Vector2i = location+direction
   if rooms.has(next) and rooms[next].get("seen",false):
    var start: Vector2 = room_rect(location).get_center()
    var finish: Vector2 = room_rect(next).get_center()
    art.corridor(self,start,finish)
    var info: Dictionary = preload("res://scripts/discovery_presentation.gd").knowledge(State,location,next)
    if info.state == "travelled": draw_line(start,finish,Color("#7B9B98"),3,true)
    elif info.state in ["known","scouted"] and info.kind != "quiet":
     markers.append({"position":start.lerp(finish,0.5),"kind":info.kind})
 var previous: Vector2i = State.room_position
 for step in preview_route:
  art.corridor(self,room_rect(previous).get_center(),room_rect(step).get_center(),true)
  previous = step
 for marker in markers:
  var mark: Vector2 = marker.position
  draw_circle(mark,11,Color("#100C12"))
  draw_arc(mark,10,0,TAU,20,Color("#B9A074"),1.5,true)
  draw_string(ThemeDB.fallback_font,mark+Vector2(-5,6),"!" if marker.kind == "ambush" else "◇",HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("#DA9C83") if marker.kind == "ambush" else Color("#D5B77B"))
 for location in rooms:
  var room: Dictionary = rooms[location]
  var rect: Rect2 = room_rect(location)
  if not room.get("seen",false):
   var frontier: bool = false
   for direction in [Vector2i.RIGHT,Vector2i.LEFT,Vector2i.UP,Vector2i.DOWN]:
    if rooms.get(location+direction,{}).get("seen",false): frontier = true
   if frontier:
    draw_rect(rect.grow(-14),Color("#19171B"))
    draw_rect(rect.grow(-14),Color("#3D353C"),false,1)
    draw_string(ThemeDB.fallback_font,rect.get_center()+Vector2(-5,7),"?",HORIZONTAL_ALIGNMENT_LEFT,-1,22,Color("#62565C"))
   continue
  var current: bool = location == State.room_position
  var tint := Color(str(COLORS.get(room.kind,"#AB9987")))
  draw_rect(rect.grow(4),Color("#07060A"))
  if tiles.has(location):
   var image: Texture2D = tiles[location]
   var source := Rect2(Vector2(image.get_width()*0.25,0),Vector2(image.get_width()*0.5,image.get_height()))
   draw_texture_rect_region(image,rect,source,Color(0.42,0.42,0.45) if room.get("cleared",false) else Color(0.7,0.64,0.6))
  draw_rect(rect,tint.darkened(0.2),false,2)
  draw_rect(Rect2(rect.position+Vector2(0,62),Vector2(rect.size.x,30)),Color(0.03,0.02,0.04,0.9))
  var title: String = "Chamber" if room.kind == "chamber" else str(room.kind).capitalize()
  if room.get("merchant_orb",false): title += " · M"
  if room.get("cleared",false): title += " ✓"
  draw_string(ThemeDB.fallback_font,rect.position+Vector2(4,83),title,HORIZONTAL_ALIGNMENT_CENTER,132,16,tint)
  var icon_rect := Rect2(rect.position+Vector2(53,12),Vector2(34,34))
  art.room(self,icon_rect,room,false)
  if current:
   draw_rect(rect.grow(7),Color(0.96,0.8,0.49,0.7+0.2*sin(clock*2.0)),false,2)
   art.party(self,rect.position+Vector2(70,-18))
  if new_rooms.has(location) and reveal_age < 4.0:
   draw_rect(rect.grow(8),Color("#CBBE95"),false,2)
   draw_string(ThemeDB.fallback_font,rect.position+Vector2(4,-12),"NEW",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("#F4D79A"))
  if preview_route.has(location): draw_rect(rect.grow(6),Color("#FFE0A0"),false,2)
