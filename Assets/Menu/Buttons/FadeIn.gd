extends ColorRect

signal fade_finished

func fade_in():
	$AnimationPlayer.play("Fade_In")


func _on_AnimationPlayer_animation_finished(_Fade_In):
	emit_signal("fade_finished")
