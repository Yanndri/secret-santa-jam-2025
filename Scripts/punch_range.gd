extends Area3D

var bloody_punch_sfx : AudioStreamMP3 = load("res://Music/punch-04-383965.mp3")
var hit_enemy_sfx_grunt : AudioStreamMP3 = load("res://Music/male-grunting-in-pain-45746.mp3")

func _ready() -> void:
	%States.connect("frame_changed", _on_frame_changed)

func _on_frame_changed():
	if %States.animation == "punch" or %States.animation == "leftpunch":
		if %States.frame == 2:
			knockback_enemy_in_front()

func knockback_enemy_in_front():
	var hit_something : bool
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			hit_something = true
			AudioUtility.add_mp3_sfx(self, bloody_punch_sfx)
			AudioUtility.add_mp3_sfx(body, hit_enemy_sfx_grunt)
			
			var explosion_force: float = 8.0
			var upward_boost: float = 0.5   #How far will flew upward
			body.apply_explosion_force(global_transform.origin, explosion_force, upward_boost)
			GlobalVariables.kills += 1
	
	if hit_something:
		EngineUtility.freeze_frame(self, 0.05, 0.3)
		CameraUtility3D.fov_kick(%Camera3D, 12, 0.2, 0.5)
