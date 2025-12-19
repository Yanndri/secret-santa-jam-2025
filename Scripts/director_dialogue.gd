extends RichTextLabel

@export var typing_duration := 2.0  # total time to reveal text

var select_sfx := load("res://Music/retro-select-236670.mp3")

var full_text := ""

var current_line_number : int
var round_started : bool

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and %E_skip.visible:
		AudioUtility.add_mp3_sfx(self, select_sfx)
		
		if round_started: 
			%E_skip.visible = false
			%DirectorPanel.visible = false
		else: #Only if the round hasn't started check start_round() function
			start_typing(get_line())

func get_line() -> String:
	var line : String
	match current_line_number:
		0: 
			disable_player_detection()
			line = "Ehemm..... Listen up."
		1: line = "We're shooting an action movie, and they said you are a good stuntman"
		2: line = " and you look a lot like our Actor"
		3: line = "So you're gonna be his double for the movie."
		4: line = "Now Listen, today here's what we want you to do"
		5: line = "You have to beat up TEN bad guys. Show me what those hands can do"
		6: 
			line = "3... 2.. 1. ACTION!"
			start_round()
			%E_skip.visible = false
			GlobalVariables.kills = 0
		7: 
			%directorAnimations.play("default")
			line = "Well that took longer than I thought."
		8: 
			%directorAnimations.play("serious")
			line = "Before we end the day we're gonna shoot another scene"
		9: line = "We are in haste for time, so try not to make any mistakes."
		10: 
			line = "3... 2.. 1. ACTION!"
			start_round()
			%E_skip.visible = false
			GlobalVariables.kills = 0
	
	current_line_number += 1
	return line

func _ready() -> void:
	start_typing(get_line())
	GlobalVariables.connect("kills_updated", check_kills)

func check_kills(kills : int):
	if kills >= 3:
		print(name, ": QUOTA REACHED")
		round_started = false
		start_typing(get_line())

func disable_player_detection():
	%Player.collision_layer = 0

func enable_player_detection():
	%Player.collision_layer = 1 << 4  # = 16 because collision layer uses bit mask

func start_round():
	round_started = true
	%directorAnimations.play("action")
	enable_player_detection()
	

	#%Player.collision_layer = 0

func start_typing(text: String) -> void:
	if text == "":
		%DirectorPanel.visible = false
		return
	else:
		%DirectorPanel.visible = true

	%E_skip.visible = false
	full_text = text
	self.text = ""

	# Create a tween to animate a counter from 0 → text length
	var tween = create_tween()
	tween.tween_method(_reveal_text, 0, full_text.length(), typing_duration)
	await tween.finished
	
	%E_skip.visible = true

func _reveal_text(char_index: int) -> void:
	# Update label text up to current index
	self.text = full_text.substr(0, char_index)
