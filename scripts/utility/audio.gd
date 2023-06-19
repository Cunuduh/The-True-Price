extends Node

@onready var synth_button: AudioStreamPlayer = $SynthButton
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	music.bus = "Master"
func _process(delta: float) -> void:
	if !music.playing:
		music.play()
