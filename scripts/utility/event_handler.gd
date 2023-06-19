class_name EventHandler
extends Node
signal event_emitted(event: Event)
signal event_progressed(in_progress: bool)
enum Event {
	GAMING,
	VAPING,
	CODING,
	REGULAR,
	REGULAR_NO_DIALOGUE,
}
var event_queued := false
var event_in_progress := false:
	set(value):
		event_in_progress = value
		emit_signal("event_progressed", value)
var current_event := Event.REGULAR:
	set(value):
		current_event = value
		emit_signal("event_emitted", value)
@onready var dialogue_holder := $"../Control/ScrollContainer/VBoxContainer"
@onready var option_holder := $"../Control/HBoxContainer"
@onready var event_picture := $"../EventPicture"
@onready var notification: TextureButton = $"../Notification"
@onready var player_vars = $"/root/PlayerVariables"
@onready var work_button: TextureButton = $"../WorkButton"

func _ready() -> void:
	connect("event_emitted", _on_event_emitted)
	connect("event_progressed", _on_event_progressed)

func request_event(event: Event) -> void:
	if event_queued:
		notification.visible = true
		notification.disabled = false
		return
	notification.visible = true
	notification.disabled = false
	event_queued = true
	await notification.pressed
	notification.visible = false
	notification.disabled = true
	event_queued = false
	current_event = event

func _clear_conversation(caller: Node) -> void:
	var dialogue_containers = caller.get_children().filter(func(child): return child is DialogueContainer) as Array[DialogueContainer]
	for dialogue_container in dialogue_containers:
		dialogue_container.queue_free()

func _on_event_progressed(in_progress: bool) -> void:
	if in_progress and current_event != Event.CODING:
		work_button.disabled = true
	else:
		work_button.disabled = false
		if current_event != Event.CODING:
			work_button.button_pressed = false

func _on_event_emitted(event: Event) -> void:
	match event:
		Event.REGULAR_NO_DIALOGUE:
			event_in_progress = false
			event_picture.texture = preload("res://textures/regular.png")
		Event.REGULAR:
			event_in_progress = true
			await _regular_event()
			event_picture.texture = preload("res://textures/regular.png")
		Event.CODING:
			event_in_progress = true
			event_picture.texture = preload("res://textures/desktop.png")
		Event.GAMING:
			event_in_progress = true
			_clear_conversation(dialogue_holder)
			await _roblox_event()
		Event.VAPING:
			event_in_progress = true
			_clear_conversation(dialogue_holder)
			await _vaping_event()

func _regular_event() -> void:
	const random_dialogue: Array[Array] = [
		[
			{
				"text": "see ya",
				"character": Dialogue.Character.NPC
			},
			{
				"text": "\\o",
				"character": Dialogue.Character.PLAYER
			},
		],
		[
			{
				"text": "bye",
				"character": Dialogue.Character.NPC
			},
			{
				"text": "see u later",
				"character": Dialogue.Character.PLAYER
			},
		],
		[
			{
				"text": "i gtg",
				"character": Dialogue.Character.PLAYER
			},
			{
				"text": "bye",
				"character": Dialogue.Character.NPC
			},
		],
	]
	var dialogue := DialogueBuilder.new() \
			.with_text(random_dialogue.pick_random()).build()
	await dialogue.staggered_display(dialogue_holder, dialogue.text)
	event_in_progress = false

func _vaping_event() -> void:
	var dialogue: Dialogue
	if player_vars.vape_hits == 0:
		if player_vars.vapes_rejected == 0:
			dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "yo wanna vape",
							"character": Dialogue.Character.NPC
						},
					]).with_responses([
						"ok",
						"not rlly"
					]).build()
		if player_vars.vapes_rejected in [1, 2]:
			dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "changed ur mind on vaping?",
							"character": Dialogue.Character.NPC
						},
					]).with_responses([
						"yeah",
						"nah"
					]).build()
		if player_vars.vapes_rejected > 2:
			dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "yo. im sorry about asking you to vape with me.",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "trying to quit it after searching about its effects online.",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "wanna game?",
							"character": Dialogue.Character.NPC
						},
					]).with_responses([
						"heck yeah",
					]).build()
	elif player_vars.vape_hits == 1:
		dialogue = DialogueBuilder.new() \
				.with_text([
					{
						"text": "yo wanna vape again",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "i got a new flavor",
						"character": Dialogue.Character.NPC
					},
				]).with_responses([
					"ok",
					"later"
				]).build()
	else:
		dialogue = DialogueBuilder.new() \
				.with_text([
					{
						"text": "yo lets go out for a vape",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "cant say no anymore, can you?",
						"character": Dialogue.Character.NPC
					},
				]).with_responses([
					"yep"
				]).build()
	await dialogue.staggered_display(dialogue_holder, dialogue.text)
	await get_tree().create_timer(1.0).timeout
	var choice := await _display_choices(option_holder, dialogue.responses)
	for child in option_holder.get_children():
		child.queue_free()
	var choice_dialogue: Dialogue
	if choice == 0:
		if player_vars.vape_hits > 1:
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "omw",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "let's have a chat",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "how are your other friends doing?",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "i cant really sleep and im getting so anxious cuz im worried im getting distant from my friends",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "so u gon vape it away huh? just like me",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "vaping isnt just a sorta thing like drinking.",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "it helps and theres no side effects. its helped with stress, anxiety and my overall mood.",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "my sleep schedule was getting pretty screwed.",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "hopefully i can just 'vape it away.'",
							"character": Dialogue.Character.PLAYER
						}
					]).build()
		elif player_vars.vape_hits == 1:
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "im coming",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "lets talk about stuff",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "so what got u into vaping?",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "peer pressure mostly, it was the hot new thing and my friends made me try it out",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "this is actually my second time vaping. thanks for getting me into it",
							"character": Dialogue.Character.PLAYER
						},
					]).build()
		elif player_vars.vape_hits == 0:
			if player_vars.vapes_rejected < 3:
				choice_dialogue = DialogueBuilder.new() \
						.with_text([
							{
								"text": "im coming",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "meet me at the park",
								"character": Dialogue.Character.NPC
							},
							{
								"text": "...",
								"character": Dialogue.Character.NPC
							},
							{
								"text": "...",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "what a surreal feeling. its...indescribable",
								"character": Dialogue.Character.PLAYER
							}
						]).build()
			else:
				choice_dialogue = DialogueBuilder.new() \
						.with_text([
							{
								"text": "heck yeah",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "...",
								"character": Dialogue.Character.NPC
							},
							{
								"text": "ive been meaning to get back into valorant",
								"character": Dialogue.Character.NPC
							},
							{
								"text": "same",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "val isnt gonna wreck my life like vaping might. actually maybe lol",
								"character": Dialogue.Character.NPC
							}
						]).build()
		event_picture.texture = preload("res://textures/vaping.png") if player_vars.vapes_rejected < 2 else preload("res://textures/desktop.png")
		player_vars.dopamine += 72 * 1 / (player_vars.vape_hits + 1)
		player_vars.vape_hits += 1 if player_vars.vapes_rejected < 3 else 0
	else:
		if player_vars.vape_hits == 0:
			if player_vars.vapes_rejected == 0:
				choice_dialogue = DialogueBuilder.new() \
						.with_text([
							{
								"text": "not rlly",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "aight. feel free to join me if u want tho",
								"character": Dialogue.Character.NPC
							}
						]).build()
			elif player_vars.vapes_rejected > 0:
				choice_dialogue = DialogueBuilder.new() \
						.with_text([
							{
								"text": "nah",
								"character": Dialogue.Character.PLAYER
							},
							{
								"text": "aight. feel free to join me if u want tho",
								"character": Dialogue.Character.NPC
							}
						]).build()
			player_vars.vapes_rejected += 1
		elif player_vars.vape_hits > 1:
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "later",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "aight. message me when",
							"character": Dialogue.Character.NPC
						}
					]).build()
		await choice_dialogue.staggered_display(dialogue_holder, choice_dialogue.text)
		current_event = Event.REGULAR
		return
	await choice_dialogue.staggered_display(dialogue_holder, choice_dialogue.text)
	await get_tree().create_timer(5.0).timeout
	current_event = Event.REGULAR

func _roblox_event() -> void:
	const random_dialogue: Array[Array] = [
		[
			{
				"text": "yo wanna play roblox",
				"character": Dialogue.Character.NPC
			},
		],
		[
			{
				"text": "lets play val",
				"character": Dialogue.Character.NPC
			},
		],
		[
			{
				"text": "hop on minecraft",
				"character": Dialogue.Character.NPC
			},
		],
		[
			{
				"text": "fortnite?",
				"character": Dialogue.Character.NPC
			}
		]
	]
	var dialogue: Dialogue
	if player_vars.vape_hits > 2:
		dialogue = DialogueBuilder.new() \
				.with_text(
					random_dialogue.pick_random()
				).with_responses([
					"not in the mood"
				]).build()
	else:
		dialogue = DialogueBuilder.new() \
				.with_text(
					random_dialogue.pick_random()
				).with_responses([
					"sure",
					"later"
				]).build()
	await dialogue.staggered_display(dialogue_holder, dialogue.text)
	await get_tree().create_timer(1.0).timeout
	var choice := await _display_choices(option_holder, dialogue.responses)
	for child in option_holder.get_children():
		child.queue_free()
	var choice_dialogue: Dialogue
	if choice == 0:
		if player_vars.vape_hits in [1, 2]:
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "sure",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "lesgo",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "i cant help but notice youve been vaping a lot lately",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "yeah, its been helping me a lot with my anxiety and stress",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "i see. i hope you dont get addicted to it",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "dont worry, i wont",
							"character": Dialogue.Character.PLAYER
						},
					]).build()
		elif player_vars.vape_hits > 2:
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "not in the mood",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "man",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "im getting a bit worried about you",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "why? im fine",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "ever heard of nicotine addiction?",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "whatever you think it helps with, it really doesnt.",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "it just makes you feel worse in the long run. and these problems the vape is helping you with, guess what caused them in the fiirst place.",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...yeah. please stop while you can",
							"character": Dialogue.Character.NPC
						}
					]).build()
		else:
			var extended_dialogue: Array[Array] = [
				[
					{
						"text": "opinions on vaping?",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "lost a friend to one.",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "she found vaping to try and cope with stress,",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "made it worse.",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "eventually...",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "ill talk about it at some better time than gaming.",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "im so sorry for asking",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "dont be. lets just get back to gaming",
						"character": Dialogue.Character.NPC
					},
				],
				[
					{
						"text": "hows your diet?",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "ok that was a bit of a strange question",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "i make my own food usually, so its not really consistent. always with rice tho.",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "cool, cool. ever since i stopped vaping, my eating habits got a lot better.",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "lost quite a few pounds not even from exercise lol",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "good stuff bro",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "lets get back to it",
						"character": Dialogue.Character.PLAYER
					}
				],
				[
					{
						"text": "worried about anything?",
						"character": Dialogue.Character.NPC
					},
					{
						"text": "i gotta get my work done still. shouldnt even be gaming rn",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "aight, we'll finish up quickly then",
						"character": Dialogue.Character.NPC
					},
				]
			]
			choice_dialogue = DialogueBuilder.new() \
					.with_text([
						{
							"text": "sure",
							"character": Dialogue.Character.PLAYER
						},
						{
							"text": "lesgo",
							"character": Dialogue.Character.NPC
						},
						{
							"text": "...",
							"character": Dialogue.Character.NPC
						}
					] + extended_dialogue.pick_random()).build()
		event_picture.texture = preload("res://textures/desktop.png")
		player_vars.dopamine += 45 if player_vars.vape_hits <= 2 else 0
	else:
		choice_dialogue = DialogueBuilder.new() \
				.with_text([
					{
						"text": "later",
						"character": Dialogue.Character.PLAYER
					},
					{
						"text": "aww",
						"character": Dialogue.Character.NPC
					}
				]).build()
		await choice_dialogue.staggered_display(dialogue_holder, choice_dialogue.text)
		current_event = Event.REGULAR
		return
	await choice_dialogue.staggered_display(dialogue_holder, choice_dialogue.text)
	await get_tree().create_timer(5.0).timeout
	current_event = Event.REGULAR

func _display_choices(caller: Node, responses: Array[String]) -> int:
	var button_group: ButtonGroup = ButtonGroup.new()
	for response in responses:
		var option_button = preload("res://option_button.tscn").instantiate()
		caller.add_child(option_button)
		var button: Button = option_button.get_node("MarginContainer/Button")
		button.text = response
		button.button_group = button_group
		option_button.visible = true
	await button_group.pressed
	return button_group.get_pressed_button().get_node("../..").get_index()

func _on_work_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		current_event = Event.CODING
		notification.visible = false
		notification.disabled = true
	else:
		current_event = Event.REGULAR_NO_DIALOGUE
