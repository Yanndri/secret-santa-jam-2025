class_name CameraUtility3D

#Rotate camera to where the mouse is looking
static func rotate_camera_to_mouse(event, mouse_sensitivity : float, player : CharacterBody3D, owner : Camera3D):
	#This is the standard FPS setup:
	player.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity)) #- Player rotates on Y → turning left/right
	owner.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))#- Camera rotates on X → looking up/down
	#This prevents weird diagonal tilting and keeps movement aligned with the ground.
	
	owner.rotation_degrees.x = clamp(owner.rotation_degrees.x, -80, 80) #-80 max look up, 80 max look down together is 160 degrees	

static func hide_cursor(): #Hide Cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #Hide Mouse Cursor
