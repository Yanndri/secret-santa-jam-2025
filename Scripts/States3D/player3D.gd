extends CharacterBody3D
class_name Player3D

@onready var faces: AnimatedSprite2D = %Faces

var take_hit_sfx : AudioStreamMP3 = load("res://Music/retro-hit-explosion-319166.mp3")
var grunt_sfx : AudioStreamMP3 = load("res://Music/grunt-1-85280.mp3")
var jump_grunt_sfx : AudioStreamMP3 = load("res://Music/jump_grunt-106134.mp3")
var punch_sfx : AudioStreamMP3 = load("res://Music/air_punch.mp3")

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

var car_speed: float = 8
var can_drive_cooldown : bool = true #Only used for cooldown
var was_going_fast : bool
var pre_speed : float #Speed before move and slide
var is_driving : bool :
	set(value):
		is_driving = value
		if is_driving:
			%States.play("driving")
			faces.play("driving")
		else:
			%States.play("default")
			faces.play("default")

var was_on_floor := false

var lefthook : bool #After throwing a punch set to true to do a left hook
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 1 or event.button_index == 2) and not %States.is_playing():
			AudioUtility.add_mp3_sfx(self, punch_sfx)
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
		if not is_driving: #can only jump when it's not driving
			AudioUtility.add_mp3_sfx(self, jump_grunt_sfx)
			velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	MovementUtility3D.basic_movement(self)
	
	#Using the Car
	if Input.is_action_just_pressed("dash") and can_drive_cooldown:
		%States.play("driving")
		is_driving = CarUtility3D.start_car() #sets is driving to true
	
	if is_driving:
		CarUtility3D.update_car(self, car_speed) 
		
		#print("was_on_floor: ", was_on_floor, " is_on_floor(): ", is_on_floor())
		if was_on_floor and not is_on_floor():
			# Just left the ground → ramp exit
			velocity.y += velocity.length() * 0.5

			print(name, ": Ramppp")

	was_on_floor = is_on_floor() #get current frame before next frame of is_on_floor so if on next frame is_on_floor is false, but was_on_floor is true, then that means player was on floor but now he isnt
	was_going_fast = (velocity.length() >= 6) #Check if going fast before move and slide, so if driving slow, and collides then it doesn't explode
	
	#MOVE AND SLIDE >>>>>>>>>>>>>
	var collision = move_and_slide()
	#<<<<<<<<<<<<<<<<<< AFTER MOVE AND SLIDE
	if is_driving:
		if was_going_fast and velocity.length() <= 3.5 and collision:  # dash stops when hitting a wall, velocity.length < 2 helps when the player is jummping while driving it doesnt explode
			print(name, ": EXPLODE CAR: ", " was_going_fast: ", was_going_fast, " current_velocity: ", velocity.length())
			is_driving = CarUtility3D.brake(self) #sets is driving to false
			explode_area() #Explode because it collides with a collision
			driving_cooldown() #so the player doesnt spam car
			return

	CameraUtility3D.apply_velocity_fov(%Camera3D, self, delta)
	
	#print(name, ":velocity.length(): ", velocity.length())

func driving_cooldown():
	can_drive_cooldown = false
	await  get_tree().create_timer(1).timeout
	can_drive_cooldown = true

func explode_area():
	%Explosion.explode_area(position + (-transform.basis.z * 0.1)) #Infront of player

@onready var bloodOverlayRect := %BloodOverlay
func get_hit():
	#hit_effect_fov()
	EngineUtility.freeze_frame(self, 0.05, 0.5)

	bloodOverlayRect.visible = true
	faces.play("take_damage")
	
	AudioUtility.add_mp3_sfx(self, take_hit_sfx)
	AudioUtility.add_mp3_sfx(self, grunt_sfx)
	await TweenUtility.fade_in_or_out(bloodOverlayRect, 0, 0.5, 0.2) #fade in to view
	
	await get_tree().create_timer(1).timeout
	
	await TweenUtility.fade_in_or_out(bloodOverlayRect, 0.5, 0, 0.3) #fade out to view
	faces.play("default")

func hit_effect_fov():
	CameraUtility3D.fov_kick(%Camera3D, 24, 0.1, 0.6)
	
