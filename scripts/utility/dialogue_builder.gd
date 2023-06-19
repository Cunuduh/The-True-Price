class_name DialogueBuilder
var _dialogue: Dialogue

func _init() -> void:
	_dialogue = Dialogue.new()

func with_text(text: Array) -> DialogueBuilder:
	_dialogue.text = text
	return self

func with_responses(responses: Array[String]) -> DialogueBuilder:
	_dialogue.responses = responses
	return self

func build() -> Dialogue:
	return _dialogue
