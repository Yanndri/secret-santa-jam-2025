extends RefCounted #Ref counted automatically releases reference once not used, saving memory
class_name State3D
#Other states will inherit this

var state_name : String = "Unnamed State" #Used by the owner to know what state they are currently in
var fps := 64 #Used for delta time, so when lagging it is still consistent

#NOTE : It's better to create a class for the owner so that you can see what function is inside the owner script

#When the state was initialized by the owner by current_state.enter, this will be called
func enter(owner: Player3D) -> void:
	pass

func update(owner: Player3D, delta: float) -> void:
	pass

func exit(owner: Player3D) -> void:
	pass
