extends Area2D

export var damage = 1

func death():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
