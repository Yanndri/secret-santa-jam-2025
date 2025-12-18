extends Camera3D

@export var player : CharacterBody3D
@export var mouse_sensitivity: float = 0.2

func _ready():
	CameraUtility3D.hide_cursor()
	TweenUtility.bob_up_and_down(self, 0.05, 0.4, 0.4)

func _input(event):
	if event is InputEventMouseMotion:
		CameraUtility3D.rotate_camera_to_mouse(event, mouse_sensitivity, player, self)
