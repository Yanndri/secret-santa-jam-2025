extends CharacterBody3D

var spawn_point : Vector3

var get_hit_sfx : AudioStreamMP3 = load("res://Music/retro-hit-explosion-319166.mp3")

@export var SPEED: float = 1.0
@export var gravity: float = 9.8
@export var stop_distance: float = 1.0
@export var player_path: NodePath = "../Player"   # assign Player node in editor

@onready var deathVFX_scene : PackedScene = load("res://death_vfx.tscn")

var player: Node = null
var can_follow_player : bool

var is_knocked_back : bool

func _ready() -> void:
	spawn_point = global_transform.origin

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
			AudioUtility.add_mp3_sfx(self, get_hit_sfx)
			get_parent().add_child(deathVFX) #add to parent because this node will be queued free
			respawn()

		return
	
	if player != null:
		if not $AnimatedSprite3D.animation == "default" and not $AnimatedSprite3D.is_playing():
			$AnimatedSprite3D.play("default")

		if $AnimatedSprite3D.animation == "default":
			EnemyUtility3D.follow_player(self, player) #Function that follows the player
		else:
			# Stop when close
			MovementUtility3D.pause(self)
	else: # Stay Put
		MovementUtility3D.pause(self)
	
	move_and_slide()

func respawn():
	position = spawn_point
	await get_tree().create_timer(0.2).timeout
	self.velocity = get_random_upward_velocity(0, 20)

func get_random_upward_velocity(min_speed: float, max_speed: float) -> Vector3:
	# Random horizontal spread
	var x = randf_range(-1.0, 1.0)
	var z = randf_range(-1.0, 1.0)
	# Always positive Y (upwards)
	var y = randf_range(0.2, 1.0)

	var dir = Vector3(x, y, z).normalized()
	var speed = randf_range(min_speed, max_speed)

	return dir * speed


func apply_explosion_force(explosion_pos: Vector3, explosion_force: float, upward_boost: float):
	ExplosionUtility3D.blow_away(self, explosion_pos, explosion_force, upward_boost)
	is_knocked_back = true


func _on_player_detection_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_player_detection_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
