extends TextureButton

@onready var audio: Node = $"/root/Audio"
func _on_pressed() -> void:
	audio.synth_button.play()
	get_tree().change_scene_to_file("res://main.tscn")
