class_name GameTimer
extends Label

@onready var timer: Timer = $Timer
@onready var _event_handler: EventHandler = $"../EventHandler"
@onready var player_vars: Node = $"/root/PlayerVariables"

func _ready() -> void:
	timer.start(300.0)
	
func _process(delta: float) -> void:
	text = "time left: %d:%02d"
	var minutes := floori(timer.time_left / 60)
	var seconds := floori(timer.time_left) % 60
	text %= [minutes, seconds]

func _emit_event() -> void:
	if $"../Notification".visible:
		return
	var random_event := randi() % 2 as EventHandler.Event
	while random_event == _event_handler.current_event:
		random_event = randi() % 2 as EventHandler.Event
	_event_handler.request_event(random_event)

func _on_one_second_timer_timeout() -> void:
	if floori(timer.time_left) % 10 == 0 and not _event_handler.event_in_progress:
		_emit_event()

func _on_timer_timeout() -> void:
	player_vars.won = false
	get_tree().change_scene_to_file("res://end_screen.tscn")
