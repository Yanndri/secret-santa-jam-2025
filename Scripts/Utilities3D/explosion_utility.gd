class_name ExplosionUtility3D

#blow away starting from the source of explosion
#explosion_force -> How strong it will blow you away
#upward_boost -> up velocity
static func blow_away(owner : CharacterBody3D, explosion_pos: Vector3, explosion_force: float, upward_boost: float):
	var dir = (owner.global_transform.origin - explosion_pos).normalized() #Where the source of the explosion are
	dir.y += upward_boost

	owner.velocity += dir.normalized() * explosion_force
