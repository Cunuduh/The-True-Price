class_name DialogueContainer
extends MarginContainer

const PATCH_MARGIN_PLAYER = [8, 3, 5, 4]
const PATCH_MARGIN_NPC = [8, 5, 3, 4]

@onready var dialogue_text: Label = $MarginContainer/VBoxContainer/DialogueText
@onready var dialogue_bubble: NinePatchRect = $DialogueBubble
@onready var vbox_container: VBoxContainer = $MarginContainer/VBoxContainer
var character: Dialogue.Character

func _ready() -> void:
	visible = false
