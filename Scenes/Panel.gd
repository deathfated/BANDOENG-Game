extends Panel

var stats = PlayerStats

func _ready():
	visible = false
	stats.connect("no_health", self, "gameover")

func gameover():
	visible = true
