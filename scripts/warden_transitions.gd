extends RefCounted
## Approved default Warden presentation; no gameplay state dependency.
static func eligible(texture: Texture2D, skill: String) -> bool:
 return texture != null and texture.get_meta("party_build","") == "warden" and skill in ["wd_slash","wd_heavy"]
static func timing(original: Dictionary, skill: String) -> Dictionary:
 var result: Dictionary = original.duplicate()
 var heavy: bool = skill == "wd_heavy"
 result["release"] = 0.44 if heavy else 0.18
 result["impact"] = 0.60 if heavy else 0.31
 result["hold"] = 0.18 if heavy else 0.07
 result["duration"] = 1.16 if heavy else 0.80
 return result
static func lean(frame: Dictionary) -> float:
 return -9*sin(frame.windup*PI/2) if frame.phase == "windup" else lerpf(-9,14,smoothstep(0,1,frame.flight)) if frame.phase == "release" else 14*(1-smoothstep(0,1,frame.recovery))
static func layers(age: float, schedule: Dictionary, _improved: bool) -> Array:
 var release: float = schedule.release
 var impact: float = schedule.impact
 var finish: float = schedule.duration
 var recover: float = impact+schedule.hold
 if age < 0 or age >= finish: return [["idle",1.0]]
 var state: String = "windup" if age < release else "attack" if age < recover else "idle"
 # Distinct painted poses cannot crossfade without doubling the held equipment.
 # Retain the grounded mesh motion and approved timing, with one opaque pose.
 return [[state,1.0]]
static func body_mesh(texture: Texture2D, anchor: Vector2, lean: float, breath: float, scale_factor: float) -> ArrayMesh:
 var vertices := PackedVector3Array()
 var uv := PackedVector2Array()
 var indices := PackedInt32Array()
 var size_px: Vector2 = texture.get_size()*scale_factor
 const COLS = 18
 const ROWS = 24
 for row in range(ROWS+1):
  for col in range(COLS+1):
   var u: float = float(col)/COLS
   var v: float = float(row)/ROWS
   var upper: float = 1.0-smoothstep(0.20,0.72,v)
   var arm: float = exp(-pow((u-0.72)/0.24,2)-pow((v-0.43)/0.24,2))
   var point := anchor+Vector2((u-0.5)*size_px.x,(v-1)*size_px.y)
   point.x += lean*upper+lean*0.22*arm
   point.y -= breath*upper+lean*0.12*arm
   vertices.append(Vector3(point.x,point.y,0))
   uv.append(Vector2(u,v))
 for row in range(ROWS):
  for col in range(COLS):
   var i: int = row*(COLS+1)+col
   indices.append_array(PackedInt32Array([i,i+1,i+COLS+1,i+1,i+COLS+2,i+COLS+1]))
 var arrays: Array = []
 arrays.resize(Mesh.ARRAY_MAX)
 arrays[Mesh.ARRAY_VERTEX] = vertices
 arrays[Mesh.ARRAY_TEX_UV] = uv
 arrays[Mesh.ARRAY_INDEX] = indices
 var mesh := ArrayMesh.new()
 mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
 return mesh
