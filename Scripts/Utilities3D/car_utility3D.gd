#This car is controlled by a CharacterBody
class_name CarUtility3D

static var is_driving : bool
static func start_car() -> bool:  #Start the car
	is_driving = true
	return is_driving

static var car_speed: float = 3
static func update_car(owner : CharacterBody3D):
	if Input.is_action_just_pressed("down"): #Brake
		brake(owner)
		return
	
	#Move the owner to where he's facing multiplied by car speed
	var forward = -owner.transform.basis.z
	owner.velocity.x = forward.x * car_speed
	owner.velocity.z = forward.z * car_speed 

static var car_brake: float = 1.0   # how fast the car slows down
static func brake(owner) -> bool: #Stop the car
	owner.velocity = owner.velocity.move_toward(Vector3.ZERO, car_brake)
	is_driving = false
	return is_driving
