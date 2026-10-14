extends SceneTree
func check(ok: bool, message: String) -> bool:
 if not ok:
  push_error(message)
  quit(1)
 return ok
func _initialize() -> void:
 if not check(ResourceLoader.exists("res://execution.gd"),"Experimental execution sequence is missing"): return
 var stage = load("res://execution.gd").new()
 if not check(not stage.begin_finish("warden",1,true,true),"A living enemy must not be executed"): return
 if not check(not stage.begin_finish("ranger",0,true,true),"Prototype must use the actual Warden attacker"): return
 if not check(not stage.begin_finish("warden",0,false,true),"Damage-over-time must not trigger a direct-hit execution"): return
 if not check(not stage.begin_finish("warden",0,true,false),"Prototype must limit executions to the final enemy"): return
 if not check(stage.begin_finish("warden",0,true,true),"A Warden direct killing blow must start the execution"): return
 if not check(not stage.begin_finish("warden",0,true,true),"The same defeat must not execute twice"): return
 var shield: Dictionary = stage.execution_sample(0.3)
 var raised: Dictionary = stage.execution_sample(0.7)
 var impact: Dictionary = stage.execution_sample(stage.FINAL_HIT)
 var done: Dictionary = stage.execution_sample(2.0)
 var held: Dictionary = stage.execution_sample(4.0)
 if not check(shield.target_pose == 0 and raised.target_pose == 1,"Raider must stagger and kneel before the finishing blow"): return
 if not check(impact.warden_pose == 2 and impact.target_pose == 2,"Finishing impact needs dedicated Warden and crushed-target poses"): return
 if not check(done.target_pose == 3 and held.target_pose == 3 and done.done,"Defeated target must remain a motionless corpse"): return
 if not check(stage.execution_particles(stage.FINAL_HIT-0.01).is_empty() and not stage.execution_particles(stage.FINAL_HIT+0.1).is_empty(),"Finishing gore must synchronize to impact"): return
 if not check(stage.execution_particles(stage.FINAL_HIT+0.1,false).is_empty(),"Reduced motion must suppress flying gore"): return
 stage.load_execution_assets()
 var before: Image = stage.render_execution(0.7)
 var after: Image = stage.render_execution(2.0)
 var later: Image = stage.render_execution(3.0)
 if not check(before.get_region(Rect2i(0,420,800,120)).get_data() == after.get_region(Rect2i(0,420,800,120)).get_data(),"Execution must keep the zero-health HUD stationary"): return
 if not check(after.get_data() == later.get_data(),"The final tableau must hold still with no revival or idle breathing"): return
 stage.free()
 print("PASS: zero-health/direct-kill/final-enemy gates, one execution per defeat, knockdown/finish/corpse order, synchronized gore, reduced motion and stable aftermath/HUD")
 quit()
