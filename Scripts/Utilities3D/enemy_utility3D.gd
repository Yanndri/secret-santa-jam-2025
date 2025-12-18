class_name EnemyUtility3D

static func follow_player(owner : CharacterBody3D, player : CharacterBody3D):
	var player_direction = get_player_direction_coordinates(owner, player)
	var direction = Vector3(player_direction.x, 0, player_direction.z).normalized() #direction to move
	
	MovementUtility3D.walk(owner, direction) #start walking

#Returns how far the owner is from the player
static func get_distance_to_player(owner : CharacterBody3D, player : CharacterBody3D) -> float:
	var player_direction = get_player_direction_coordinates(owner, player)
	
	var distance = player_direction.length()
	return distance

#Get the direction coordinates of the player from the perspective of the owner
static func get_player_direction_coordinates(owner : CharacterBody3D, player : CharacterBody3D) -> Vector3:
	var player_direction := player.global_transform.origin - owner.global_transform.origin # Direction toward player (XZ plane only)
	return player_direction
