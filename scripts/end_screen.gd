extends Node2D

@onready var player_vars = $"/root/PlayerVariables"
@onready var audio = $"/root/Audio"
func _ready() -> void:
	audio.music.bus = "Master"
	$ScoreNumber.text = "%d" % player_vars.get_score()
	if player_vars.won:
		$WinOrLose.texture = preload("res://textures/win_icon.png")
	else:
		$WinOrLose.texture = preload("res://textures/loss_icon.png")

