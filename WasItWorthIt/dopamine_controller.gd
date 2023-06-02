class_name DopamineController
extends Node

signal dopamine_change(dopamine: int)

var dopamine: int:
	set(value):
		if value < 0:
			dopamine = 0
		else:
			dopamine = value
		emit_signal("dopamine_change", dopamine)
var dopamine_bar: TextureProgressBar
var dopamine_timer: Timer

func _ready() -> void:
	dopamine_bar = get_node("../Control/DopamineProgress")
	dopamine_timer = get_node("../DopamineTimer")
	connect("dopamine_change", on_dopamine_change)
	dopamine_timer.connect("timeout", check_dopamine)
	dopamine = 0

func on_dopamine_change(new_dopamine: int) -> void:
	dopamine_bar.value = new_dopamine
	if dopamine <= 0:
		dopamine_timer.start(10.0)
	else:
		dopamine_timer.stop()

func check_dopamine() -> void:
	if dopamine <= 0:
		emit_signal("dopamine_change", 0)
	else:
		dopamine_timer.stop()

func get_dopamine() -> int:
	return dopamine

func set_dopamine(new_dopamine: int) -> void:
	dopamine = new_dopamine
	emit_signal("dopamine_change", dopamine)
