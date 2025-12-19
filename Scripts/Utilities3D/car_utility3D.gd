#This car is controlled by a CharacterBody
class_name CarUtility3D

static var current_speed := 0.0 #current speed of the car
static var steering_angle := 0.0 #where the car is looking
static var target_angle := 0.0 #For smoother steering

static var is_driving : bool
static func start_car() -> bool:  #Start the car
	is_driving = true
	return is_driving

static func update_car(owner : CharacterBody3D, car_speed : float):
	if Input.is_action_pressed("jump"): #Brake
		current_speed = lerp(current_speed, 0.0, 0.1)
		return


	if Input.is_action_pressed("up"):
		# accelerate toward car_speed
		current_speed = lerp(current_speed, car_speed, 0.05)
	elif Input.is_action_pressed("down"):
		# decelerate back to 0 when not pressing
		current_speed = lerp(current_speed, -car_speed, 0.005)
	else:
		current_speed = lerp(current_speed, 0.0, 0.03)

	# --- STEERING ---
	if Input.is_action_pressed("right"):
		target_angle -= 0.05  # turn left
	elif Input.is_action_pressed("left"):
		target_angle += 0.05  # turn right
	
	# --- APPLY ROTATION ---
	steering_angle = lerp(steering_angle, target_angle, 0.1)

	owner.rotation.y = steering_angle

	# --- FORWARD MOTION (based on car orientation) ---
	var forward = -owner.transform.basis.z
	owner.velocity.x = forward.x * current_speed
	owner.velocity.z = forward.z * current_speed



static var car_brake: float = 1.0   # how fast the car slows down
static func brake(owner) -> bool: #Stop the car
	owner.velocity = owner.velocity.move_toward(Vector3.ZERO, car_brake)
	is_driving = false
	return is_driving
