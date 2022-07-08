extends Area2D

#export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position #- Vector2(0,8)
	
func death():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
	
func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)
