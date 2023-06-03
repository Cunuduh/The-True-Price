class_name DialogueBuilder
var _dialogue := Dialogue.new()

func _init() -> void:
	_dialogue.resultant = Callable(self, "_default_resultant")

func with_text(text: Array[Dictionary]) -> DialogueBuilder:
	_dialogue.text = text
	return self

func with_responses(responses: Dictionary) -> DialogueBuilder:
	_dialogue.responses = responses
	return self

func with_resultant(resultant: Callable) -> DialogueBuilder:
	_dialogue.resultant = resultant
	return self

func select_responses(responses: Array) -> DialogueBuilder:
	for response in responses:
		_dialogue.responses[response] = true
	return self

func build() -> Dialogue:
	return _dialogue

func _default_resultant() -> void:
	pass

func get_responses() -> Dictionary:
	return _dialogue.responses

func set_responses(responses: Dictionary) -> void:
	_dialogue.responses = responses
