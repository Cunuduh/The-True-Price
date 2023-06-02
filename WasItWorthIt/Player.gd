class_name Player
extends Node

signal interaction_score_change(interaction_score: Dictionary)

var _vape_hits: int = 0
var _dopamine_controller: DopamineController

func _ready() -> void:
	_dopamine_controller = get_node("../DopamineController") as DopamineController
	connect("interaction_score_change", on_interaction_score_change)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var event_key = event as InputEventKey
		match event_key.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				_vape_hits += 1
				var dopamine = 50 * 1 / _vape_hits
				_dopamine_controller.dopamine += dopamine
			KEY_CTRL:
				var dialogue: Dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "Why did the chicken cross the road?",
							"character": Dialogue.Characters.NPC
						},
						{
							"text": "I don't know, why?",
							"character": Dialogue.Characters.PLAYER
						},
						{
							"text": "To get to the other side!",
							"character": Dialogue.Characters.NPC
						},
						{
							"text": "We are no longer friends.",
							"character": Dialogue.Characters.PLAYER
						},
						{
							"text": "I'm sorry!!",
							"character": Dialogue.Characters.NPC
						},
						{
							"text": "just kidding lol",
							"character": Dialogue.Characters.PLAYER
						}
					]).build()
				var container = get_node("../Control/ScrollContainer/VBoxContainer")
				dialogue.display(container, dialogue.text)

func on_interaction_score_change(interaction_score: Dictionary) -> void:
	for interaction in interaction_score:
		print(interaction, ": ", interaction_score[interaction])
