extends Node

var kills : int :
	set(value):
		kills = value
		emit_signal("kills_updated", kills)

signal kills_updated
