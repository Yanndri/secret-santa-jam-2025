class_name MovementUtility3D

static func basic_movement(owner : CharacterBody3D):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		owner.velocity.x = direction.x * owner.SPEED
		owner.velocity.z = direction.z * owner.SPEED
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, owner.SPEED)
		owner.velocity.z = move_toward(owner.velocity.z, 0, owner.SPEED)
