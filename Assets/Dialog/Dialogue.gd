class_name DialogueBox
extends Control

#signal dialogue_ended()

onready var content = $Content as RichTextLabel
onready var type_timer = $TypeTimer as Timer
#onready var pause_timer := get_node("PauseTimer") as Timer
onready var voicePlayer = $DialogueVoicePlayer as AudioStreamPlayer

var dialog = ["Ucup looks over to the horizon and spots some intimidating NICA soldiers. Sneaking around isn't an option...", "There is a bamboo spear nearby, the young man might have to fight his way to the Camat..."]
var page = 0

func _ready() -> void:
	#yield(get_tree().create_timer(1.0),"timeout")
	content.set_bbcode(dialog[page])
	content.set_visible_characters(0)
	set_process_input(true)

func _input(_event):
	#if event.type == InputEventKey && event.is_pressed():
	if Input.is_action_just_pressed("interact"):
		if content.get_visible_characters() == content.get_total_character_count():
			#if all characters in page is visible, move to next page on input
			if page < dialog.size()-1:
				page += 1
				content.set_bbcode(dialog[page])
				content.set_visible_characters(0)
		#if not all char visible but input, auto complete the page
		else:
			content.set_visible_characters(content.get_total_character_count())
		
		type_timer.start()
		#voicePlayer.play(0)

func _on_TypeTimer_timeout():
	content.set_visible_characters(content.get_visible_characters()+1)
	#content.visible_characters += 1
			
	#else:
	#	type_timer.stop()
	#	voicePlayer.stop()
