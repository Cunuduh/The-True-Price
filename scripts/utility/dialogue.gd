class_name Dialogue
enum Character {
	PLAYER,
	NPC
}
var text: Array
# [String, Characters]
var responses: Array[String]

func _init() -> void:
	text = []
	responses = []

func display(caller: Node, lines: Array) -> void:
	var previous: DialogueContainer = null
	for line in lines:
		var dialogue_container = preload("res://dialogue_container.tscn").instantiate()
		caller.add_child(dialogue_container)
		dialogue_container.dialogue_text.text = word_wrap(line["text"])
		dialogue_container.character = line["character"]
		if dialogue_container.character == Character.PLAYER:
			dialogue_container.dialogue_bubble.texture = preload("res://textures/self_message.png")
			dialogue_container.layout_direction = Control.LAYOUT_DIRECTION_RTL
			dialogue_container.dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			dialogue_container.size_flags_horizontal = Control.SIZE_SHRINK_END
			dialogue_container.dialogue_bubble.patch_margin_bottom = DialogueContainer.PATCH_MARGIN_PLAYER[0]
			dialogue_container.dialogue_bubble.patch_margin_left = DialogueContainer.PATCH_MARGIN_PLAYER[1]
			dialogue_container.dialogue_bubble.patch_margin_right = DialogueContainer.PATCH_MARGIN_PLAYER[2]
			dialogue_container.dialogue_bubble.patch_margin_top = DialogueContainer.PATCH_MARGIN_PLAYER[3]
		else:
			dialogue_container.dialogue_bubble.texture = preload("res://textures/npc_message.png")
			dialogue_container.layout_direction = Control.LAYOUT_DIRECTION_LTR
			dialogue_container.dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			dialogue_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			dialogue_container.dialogue_bubble.patch_margin_bottom = DialogueContainer.PATCH_MARGIN_NPC[0]
			dialogue_container.dialogue_bubble.patch_margin_left = DialogueContainer.PATCH_MARGIN_NPC[1]
			dialogue_container.dialogue_bubble.patch_margin_right = DialogueContainer.PATCH_MARGIN_NPC[2]
			dialogue_container.dialogue_bubble.patch_margin_top = DialogueContainer.PATCH_MARGIN_NPC[3]
		dialogue_container.visible = true
		previous = dialogue_container
	var dialogue_containers = caller.get_children().filter(func(child): return child is DialogueContainer)
	previous = null
	for i in range(dialogue_containers.size()):
		var dialogue_container = dialogue_containers[i]
		dialogue_container.position.y = calculate_y_size(word_wrap(previous.dialogue_text.text)) + int(previous.position.y) if previous != null else 0
		previous = dialogue_container

func calculate_y_size(input_text: String) -> int:
	var lines = input_text.split("\n")
	return 6 * lines.size() + 6

func word_wrap(input_text: String) -> String:
	const MAX_LINE_LENGTH := 15
	var words := input_text.split(" ")
	var lines: Array[String] = []
	var current_line := ""
	for word in words:
		if current_line.length() + word.length() > MAX_LINE_LENGTH:
			lines.append(current_line)
			current_line = ""
		current_line += word + " "
	if current_line.length() > 0:
		lines.append(current_line)
	var ret: Array[String] = []
	for line in lines:
		var substrings: Array[String] = []
		for i in range(0, line.length(), MAX_LINE_LENGTH):
			substrings.append(line.substr(i, MAX_LINE_LENGTH).strip_edges())
		ret.append("\n".join(substrings).strip_edges())
	return "\n".join(ret).strip_edges()

func select_response(selected_response: String, handler: Callable) -> void:
	handler.call(selected_response)

func staggered_display(caller: Node, lines: Array) -> void:
	for line in lines:
		await caller.get_tree().create_timer(randf_range(1.0, 2.0)).timeout
		display(caller, [line])
