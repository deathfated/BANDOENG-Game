extends Node2D

var grassEffect = load("res://Effects/GrassEffect.tscn").instance()

func create_grass_effect():
	#var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	#var world = get_tree().current_Scene
	#world.add_child(grassEffect)
	get_tree().current_scene.add_child(grassEffect)

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
