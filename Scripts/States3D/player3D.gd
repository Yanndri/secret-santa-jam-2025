extends CharacterBody3D
class_name Player3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

var is_driving : bool :
	set(value):
		%Driving.visible = value
		%Clench.visible = !value
		is_driving = value

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
	if Input.is_action_just_pressed("dash"):
		is_driving = CarUtility3D.start_car() #sets is driving to true
	
	if is_driving:
		CarUtility3D.update_car(self) 
		
		var collision = move_and_slide()
		if collision:  # dash stops when hitting a wall
			is_driving = CarUtility3D.brake(self) #sets is driving to false
			explode_area() #Explode because it crashes
			return

	move_and_slide()

func explode_area():
	%Explosion.position = position + (-transform.basis.z * 0.1) #slightly infront of player
