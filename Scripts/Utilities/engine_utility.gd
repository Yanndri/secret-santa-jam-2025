class_name EngineUtility

static func freeze_frame(onwer : Node, timescale := 0.05, duration := 0.2):
	#timescale -> how slow the time is gonna run during freeze frame, set to 0 to full freeze
	#duration how long the freezeframe lasts
	Engine.time_scale = timescale
	await onwer.get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0
