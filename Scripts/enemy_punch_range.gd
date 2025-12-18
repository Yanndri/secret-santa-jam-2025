extends Area3D

@onready var animated_sprite_3d: AnimatedSprite3D = $"../AnimatedSprite3D"
var player_in_range : bool

func _ready() -> void:
	animated_sprite_3d.connect("frame_changed", _on_frame_changed)

func _process(delta: float) -> void:
	if player_in_range: #Check if player is in range of an attack
		if animated_sprite_3d.animation != "attack": #if animation is not attack 
			animated_sprite_3d.play("attack") #switch to attack

func _on_frame_changed():
	if animated_sprite_3d.animation == "attack": #Check if the animation is attack
		if animated_sprite_3d.frame == 2: #check when it is on frame 2 which is when the arm is gonna hit
			hit_player()

func hit_player():
	var hit_something : bool
	for body in get_overlapping_bodies(): #Get all bodies in range
		if body.is_in_group("player"): #get the player
			hit_something = true #We could technically just put the block of code below here and erase the hit_something variable
			#but since this is inside a for loop, there might be a time when there are more than 1 player in range
			body.get_hit() 
	
	if hit_something:
		EngineUtility.freeze_frame(self, 0.05, 0.3)
		CameraUtility3D.fov_kick(%Camera3D, 24, 0.1, 0.6)

func _on_attack_detection_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"): #Check if player is in range of an attack
		animated_sprite_3d.play("attack")
		player_in_range = true

func _on_attack_detection_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"): #Check if player exited the range of attack
		player_in_range = false
