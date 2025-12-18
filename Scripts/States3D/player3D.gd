extends CharacterBody3D
class_name Player3D

@onready var faces: AnimatedSprite2D = %Faces

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

var can_drive : bool = true
var is_driving : bool :
	set(value):
		is_driving = value
		if is_driving:
			%States.play("driving")
			faces.play("driving")
			CameraUtility3D.change_fov(%Camera3D, 50, 0.3)
		else:
			%States.play("default")
			faces.play("default")
			CameraUtility3D.default_fov(%Camera3D, 0.4)


var lefthook : bool #After throwing a punch set to true to do a left hook
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 1 or event.button_index == 2) and not %States.is_playing():
			if lefthook:
				%States.play("leftpunch")
				lefthook = false
			else:
				%States.play("punch")
				lefthook = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	MovementUtility3D.basic_movement(self)
	
	#Using the Car
	if Input.is_action_just_pressed("dash") and can_drive:
		is_driving = CarUtility3D.start_car() #sets is driving to true
	
	if is_driving:
		CarUtility3D.update_car(self) 
		
		var collision = move_and_slide()
		print("velocity.length(): ", velocity.length())
		if velocity.length() < 2.3 and collision:  # dash stops when hitting a wall, velocity.length < 2 helps when the player is jummping while driving it doesnt explode
			is_driving = CarUtility3D.brake(self) #sets is driving to false
			explode_area() #Explode because it collides with a collision
			driving_cooldown() #so the player doesnt spam car
			return

	move_and_slide()

func driving_cooldown():
	can_drive = false
	await  get_tree().create_timer(1).timeout
	can_drive = true

func explode_area():
	%Explosion.explode_area(position + (-transform.basis.z * 0.1)) #Infront of player
	#position = position + (-transform.basis.z * 0.1) #slightly infront of player

@onready var bloodOverlayRect := %BloodOverlay
func get_hit():
	bloodOverlayRect.visible = true
	faces.play("take_damage")
	await TweenUtility.fade_in_or_out(bloodOverlayRect, 0, 0.5, 0.2) #fade in to view
	
	await get_tree().create_timer(1).timeout
	
	await TweenUtility.fade_in_or_out(bloodOverlayRect, 0.5, 0, 0.3) #fade out to view
	faces.play("default")
