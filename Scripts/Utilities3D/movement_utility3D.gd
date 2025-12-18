class_name MovementUtility3D

static func basic_movement(owner : CharacterBody3D):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		walk(owner, direction)
	else:
		pause(owner)

static func walk(owner : CharacterBody3D, direction : Vector3):
	owner.velocity.x = direction.x * owner.SPEED
	owner.velocity.z = direction.z * owner.SPEED

static func pause(owner : CharacterBody3D):
	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.SPEED)
	owner.velocity.z = move_toward(owner.velocity.z, 0, owner.SPEED)
