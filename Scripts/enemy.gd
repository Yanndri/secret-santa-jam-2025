extends CharacterBody3D

@export var SPEED: float = 1.0
@export var gravity: float = 9.8
@export var stop_distance: float = 1.0
@export var player_path: NodePath = "../Player"   # assign Player node in editor

@onready var deathVFX_scene : PackedScene = load("res://death_vfx.tscn")

var player: Node = null
var can_follow_player : bool

var is_knocked_back : bool

func _physics_process(delta):
	# Apply gravity (falling velocity)
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_knocked_back:
		# Apply friction to slow down
		var friction = 8.0
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)

		var collision = move_and_slide()
		# Stop knockback when slow enough or on collision
		if velocity.length() < 0.2 or collision:
			is_knocked_back = false

			var deathVFX = deathVFX_scene.instantiate()
			deathVFX.position = global_transform.origin
			get_parent().add_child(deathVFX) #add to parent because this node will be queued free
			self.queue_free()

		return
	
	if player != null:
		if not $AnimatedSprite3D.animation == "default" and not $AnimatedSprite3D.is_playing():
			$AnimatedSprite3D.play("default")

		if $AnimatedSprite3D.animation == "default":
			EnemyUtility3D.follow_player(self, player) #Function that follows the player
	else:
		# Stop when close
		MovementUtility3D.pause(self)
	
	move_and_slide()

func apply_explosion_force(explosion_pos: Vector3, explosion_force: float, upward_boost: float):
	ExplosionUtility3D.blow_away(self, explosion_pos, explosion_force, upward_boost)
	is_knocked_back = true


func _on_player_detection_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_player_detection_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
