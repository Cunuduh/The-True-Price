extends TextureButton

@onready var player_vars = $"/root/PlayerVariables"
@onready var audio = $"/root/Audio"

func _on_pressed() -> void:
	audio.synth_button.play()
	player_vars.reset_all()
	get_tree().change_scene_to_file("res://main.tscn")
