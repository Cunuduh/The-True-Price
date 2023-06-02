class_name DialogueContainer
extends MarginContainer

var dialogue_text: Label
var dialogue_bubble: NinePatchRect
var vbox_container: VBoxContainer
var character: Dialogue.Characters


const PATCH_MARGIN_PLAYER = [8, 3, 5, 4]
const PATCH_MARGIN_NPC = [8, 5, 3, 4]

func _ready() -> void:
	dialogue_text = $MarginContainer/VBoxContainer/DialogueText
	dialogue_bubble = $DialogueBubble
	vbox_container = $MarginContainer/VBoxContainer
	visible = false
