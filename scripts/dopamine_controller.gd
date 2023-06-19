class_name DopamineController
extends Node

signal dopamine_changed(dopamine: int)

@onready var dopamine_bar := $"../Control/DopamineProgress"
@onready var player_vars = $"/root/PlayerVariables"
@onready var work_progress: TextureProgressBar = $"../Control/WorkProgress"
@onready var event_handler: EventHandler = $"../EventHandler"
@onready var work_percentage: Label = $"../WorkPercentage"
@onready var dopamine_percentage: Label = $"../DopaminePercentage"
@onready var audio = $"/root/Audio"

func _ready() -> void:
	dopamine_bar.value = 75
	dopamine_percentage.text = "%d%%" % 75
	player_vars.work_value_changed.connect(_on_work_value_changed)
	player_vars.dopamine_value_changed.connect(_on_dopamine_value_changed)

func _on_work_value_changed(value: int) -> void:
	work_progress.value = value
	if player_vars.dopamine > 0:
		work_percentage.text = "%d%%" % value
	if player_vars.work == 100:
		player_vars.won = true
		get_tree().change_scene_to_file("res://end_screen.tscn")

func _on_dopamine_value_changed(value: int) -> void:
	dopamine_bar.value = value
	dopamine_percentage.text = "%d%%" % value if value > 0 else ":("
	if player_vars.dopamine == 0:
		work_percentage.text = "not feeling it."
		audio.music.bus = "Muffled"
	else:
		work_percentage.text = "%d%%" % player_vars.work
		audio.music.bus = "Master"

func _on_three_second_timer_timeout() -> void:
	player_vars.dopamine -= player_vars.vape_hits + 1 + (2 if event_handler.current_event == EventHandler.Event.CODING else 0)
	player_vars.average_dopamine.append(player_vars.dopamine)
	if event_handler.current_event == EventHandler.Event.CODING:
		player_vars.work += 0 if player_vars.dopamine == 0 else 1 if player_vars.dopamine < 50 else 2
