class_name Player
extends Node

signal interaction_score_changed(interaction_score: Dictionary)

var _vape_hits := 0
var _dopamine_controller: DopamineController

func _ready() -> void:
	_dopamine_controller = get_node("../DopamineController")
	connect("interaction_score_changed", on_interaction_score_change)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				_vape_hits += 1
				var dopamine := 50 * 1 / _vape_hits
				_dopamine_controller.dopamine += dopamine
			KEY_CTRL:
				var dialogue := DialogueBuilder.new() \
						.with_text([
							{
								"text": "Does the black moon howl?",
								"character": Dialogue.Characters.NPC
							},
							{
								"text": "There is no black moon, and it does not howl.",
								"character": Dialogue.Characters.PLAYER
							},
							{
								"text": "Look up at the sky. It calls unto us a new age.",
								"character": Dialogue.Characters.NPC
							},
							{
								"text": "When the world is ground into dust, what is left?",
								"character": Dialogue.Characters.NPC
							},
							{
								"text": "The black moon's howl.",
								"character": Dialogue.Characters.NPC
							}
						]).build()
				var container = get_node("../Control/ScrollContainer/VBoxContainer")
				dialogue.display(container, dialogue.text)

func on_interaction_score_change(interaction_score: Dictionary) -> void:
	for interaction in interaction_score:
		print(interaction, ": ", interaction_score[interaction])
