extends Node2D
## Child of the presentation actor, so camera, lunge and material stay shared.
const Motion = preload("res://scripts/warden_transitions.gd")
const Builds = preload("res://scripts/party_builds.gd")
static var textures: Dictionary = {}
var meshes: Array[ArrayMesh] = []
var layers: Array = []
var anchor: Vector2
var factor: float
var lean: float
var breath: float
func update_frame(original: Texture2D, size_px: Vector2, idle_height: float, age: float, timing: Dictionary, frame: Dictionary, strength: float, ambient: bool) -> void:
 for state in ["idle","windup","attack"]:
  if not textures.has(state):
   var pose: AtlasTexture = Builds.pose(original,state)
   # AtlasTexture.get_image() crops away margins. Restore the registered canvas
   # before meshing, so weapons changing width cannot shift the body pivot.
   var raster := Image.create(pose.get_width(),pose.get_height(),false,Image.FORMAT_RGBA8)
   var pixels: Image = pose.get_image()
   raster.blit_rect(pixels,Rect2i(Vector2i.ZERO,pixels.get_size()),Vector2i(pose.margin.position))
   textures[state] = ImageTexture.create_from_image(raster)
 anchor = Vector2(size_px.x/2,size_px.y)
 factor = idle_height/float(original.get_height())
 layers = Motion.layers(age,timing,true)
 lean = Motion.lean(frame)*strength
 breath = sin(age*2.2)*1.2*strength if ambient else 0.0
 queue_redraw()
func _draw() -> void:
 meshes.clear()
 for layer in layers:
  if layer[1] <= 0.001: continue
  var texture: Texture2D = textures[layer[0]]
  var mesh: ArrayMesh = Motion.body_mesh(texture,anchor,lean,breath,factor)
  meshes.append(mesh)
  draw_mesh(mesh,texture,Transform2D.IDENTITY,Color(1,1,1,layer[1]))
