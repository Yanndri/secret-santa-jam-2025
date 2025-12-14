extends Camera3D

@export var player : CharacterBody3D
@export var mouse_sensitivity: float = 0.2

func _ready():
	CameraUtility3D.hide_cursor()

func _input(event):
	if event is InputEventMouseMotion:
		CameraUtility3D.rotate_camera_to_mouse(event, mouse_sensitivity, player, self)
