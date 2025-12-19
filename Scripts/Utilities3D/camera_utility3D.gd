class_name CameraUtility3D

static var base_camera_fov := 75

#Rotate camera to where the mouse is looking
static func rotate_camera_to_mouse(event, mouse_sensitivity : float, player : CharacterBody3D, owner : Camera3D):
	var scaled_sens = mouse_sensitivity * Engine.time_scale

	#This is the standard FPS setup:
	player.rotate_y(deg_to_rad(-event.relative.x * scaled_sens)) #- Player rotates on Y → turning left/right
	owner.rotate_x(deg_to_rad(-event.relative.y * scaled_sens))#- Camera rotates on X → looking up/down
	#This prevents weird diagonal tilting and keeps movement aligned with the ground.
	
	owner.rotation_degrees.x = clamp(owner.rotation_degrees.x, -80, 80) #-80 max look up, 80 max look down together is 160 degrees	

static func hide_cursor(): #Hide Cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #Hide Mouse Cursor

static func fov_kick(owner : Camera3D, fov_amount := 10.0, transition_in_speed := 0.08, transition_out_speed := 0.15):
	var tween = owner.create_tween()

	# ease in
	tween.tween_property(owner, "fov", base_camera_fov + fov_amount, transition_in_speed)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	# ease out
	tween.tween_property(owner, "fov", base_camera_fov, transition_out_speed)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

static func change_fov(owner : Camera3D, fov_amount := 10.0, transition_in_speed := 0.5):
	# high fov_amount = like a very speed pov , while low fov_amount is a very slow pov, 0 fov = normal fov not 75 since we are only adding to the camera's fov
	var tween = owner.create_tween()
	
	tween.tween_property(owner, "fov", base_camera_fov + fov_amount, transition_in_speed)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

static func default_fov(owner : Camera3D, transition_in_speed := 0.5):
	# high fov_amount = like a very speed pov , while low fov_amount is a very slow pov, 0 fov = normal fov not 75 since we are only adding to the camera's fov
	var tween = owner.create_tween()
	
	tween.tween_property(owner, "fov", 75, transition_in_speed)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

#Change fov based on speed
static func apply_velocity_fov(camera: Camera3D, body: CharacterBody3D, delta):
	#print("CameraUtility3D: camera.fov: ", camera.fov)
	var speed = body.velocity.length() #Get the velocity of the player, includes falling velocity
	const max_fov : int = 360 
	const max_speed : int = 100 #Max fast the player can go
	var weight = clamp(speed / max_speed, 0.0, 1.0) #how fast the fov will transition from base fov
	var target_fov = lerp(base_camera_fov, max_fov, weight)
	camera.fov = lerp(camera.fov, target_fov, delta * 5.0)
	
