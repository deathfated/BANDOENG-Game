extends Area2D

export var dialog_key = ""

#autotrigger true = triggers when collide ||  false = needs input trigger
export var autotrigger = true
export var repeatable = false

var firstTime = true
var area_active = false

func _input(event):
	if firstTime == true:
		if autotrigger == false:
			if area_active and event.is_action_pressed("interact"):
				fire_dial()
				firstTime = false
				#fire_signal()

#func fire_signal():
#	SignalBus.emit_signal("display_dialog", dialog_key)

func fire_dial():
	get_tree().paused = true
	var new_dial = Dialogic.start(dialog_key)
	add_child(new_dial)
	new_dial.connect("timeline_end", self, "dialog_end")
	new_dial.connect("dialogic_signal", self, "change_scene")

func _on_DialoArea_area_entered(_area):
	area_active = true
	if autotrigger == true:
		#fire_signal()
		#autotrigger = false
		fire_dial()

func _on_DialoArea_area_exited(_area):
	area_active = false
	if repeatable == false:
		self.set_deferred("monitorable", false)
		self.set_deferred("monitoring", false)

func dialog_end(_timeline_name):
	get_tree().paused = false
	if repeatable == true:
		firstTime = true

func change_scene(argument):
	if argument == "changeScene":
		yield(get_tree().create_timer(2), "timeout")
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/PreAlphaCredit.tscn")
