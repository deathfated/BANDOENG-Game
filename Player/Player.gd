extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 200
const FRICTION = 500

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/BambooAttack/blend_position", input_vector)
		animationState.travel("Run")
#		if input_vector.x > 0:
#			animationPlayer.play("RunRight")
#		else:
#			animationPlayer.play("RunLeft")

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#		velocity += input_vector * ACCELERATION * delta
#		velocity = velocity.clamped(MAX_SPEED * delta)
	
	else:
#		animationPlayer.play("IdleRight")
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
			state = ATTACK

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("BambooAttack")

func attack_animation_finished():
	state = MOVE

#func attack_anim_left():
#	show()
#	setvisible("AttackLSprite")
