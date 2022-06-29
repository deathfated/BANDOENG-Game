extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 200
export var FRICTION = 500

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var bambooHitbox = $HitboxPivot/BambooHitbox
onready var hurtbox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	bambooHitbox.knockback_vector = roll_vector

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
		roll_vector = input_vector
		bambooHitbox.knockback_vector = input_vector
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


func _on_Hurtbox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
