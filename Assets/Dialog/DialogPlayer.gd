extends CanvasLayer

export (String, FILE, "*json") var scene_text_file

var scene_text = {}
var selected_text = []
var in_progress = false

onready var background = $Background
onready var text_label = $DLabel
onready var dtimer = $DTimer
onready var dvoice_player = $DVoicePlayer

func _ready():
	scene_text = load_scene_text()
# warning-ignore:return_value_discarded
	SignalBus.connect("display_dialog", self, "on_display_dialog")

func load_scene_text():
	var file = File.new()
	if file.file_exists(scene_text_file):
		file.open(scene_text_file, File.READ)
		return parse_json(file.get_as_text())

func show_text():
	text_label.set_bbcode(selected_text.pop_front())

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
	dvoice_player.stop()

func on_display_dialog(text_key):
	if in_progress:
		#flip to next page
		#if text_label.get_visible_characters() == text_label.get_total_character_count():
			
			if selected_text.size() > 0:
				text_label.set_visible_characters(0)
				show_text()
			else:
				finish()
		
		#else:
		#	text_label.set_visible_characters(text_label.get_total_character_count())
	
	else:
		get_tree().paused = true
		background.visible= true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()
		
		dtimer.start()
		dvoice_player.play()

func _on_DTimer_timeout():
	text_label.set_visible_characters(text_label.get_visible_characters()+1)
	dvoice_player.stop()
	dtimer.stop()
