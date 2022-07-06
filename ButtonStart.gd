extends Button

var font_color = Color(0.5,0.5,0.5,0.5)
var font_color_pressed = Color(1, 1, 1, 1)

func _ready():
	var button = Button.new()
	button.text = "Click me"
	button.connect("pressed", self, "_button_pressed")
	add_child(button)

#func _button_pressed():
#	change_scene("res://World.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
