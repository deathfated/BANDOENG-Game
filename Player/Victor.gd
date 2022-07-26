extends KinematicBody2D

#const EnemyDeathEffect = preload("res://Effects/EnemyDENica.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	CHEER
#	WANDER,
#	CHASE,
#	ATTACK,
#	DEATH
}

#var state = CHASE
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var enemyisded = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var sprite = $Sprite
#onready var stats = $Stats
#onready var playerDetectionZone = $PlayerDetectionZone
#onready var hurtbox = $Hurtbox
#onready var hitbox = $Hitbox
#onready var softCollision = $SoftCollision
#onready var wanderController = $WanderController
#onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animationTree.active = true
	state = IDLE
	#state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			#seek_player()
			#if wanderController.get_time_left() == 0:
			#	update_wander()
		
		CHEER:
				animationState.travel("Cheer")
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		#WANDER:
		#	seek_player()
		#	if wanderController.get_time_left() == 0:
		#		update_wander()
		#	accelerate_towards_point(wanderController.target_position, delta)
		#	if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
		#		update_wander()
			
		#CHASE:
		#	var player = playerDetectionZone.player
		#	if player != null:
		#		accelerate_towards_point(player.global_position, delta)
		#		#= (player.global_position - global_position).normalized()
		#	else:
		#		state = IDLE
		#	
		#	if enemyisded == true:
		#		state = DEATH
			#sprite.flip_h = velocity.x < 0
		#ATTACK:
		#	attack_state(delta)
			
		#DEATH:
		#	velocity = Vector2.ZERO

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = IDLE
	

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animationTree.set("parameters/Idle/blend_position", direction)
	#animationTree.set("parameters/Run/blend_position", direction)
	#animationTree.set("parameters/Death/blend_position", direction)
	#animationTree.set("parameters/Attack/blend_position", direction)
	animationTree.set("parameters/Cheer")
	
	#animationState.travel("Run")

#func seek_player():
#	if playerDetectionZone.can_see_player():
#		state = CHASE

#func update_wander():
#	state = pick_random_state([IDLE, WANDER])
#	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

#func _on_Hurtbox_area_entered(area):
#	stats.health -= area.damage
#	knockback = area.knockback_vector * 150
	#queue_free()
#	hurtbox.create_hit_effect()
#	hurtbox.start_invincibility(0.4)

#func _on_Stats_no_health():
#	enemyisded = true
#	state = DEATH
#	hurtbox.death()
#	hitbox.death()
#	set_collision_layer_bit(4, false)
#	animationState.travel("Death")
	#queue_free()
	#var enemyDeathEffect = EnemyDeathEffect.instance()
	#get_parent().add_child(enemyDeathEffect)
	#enemyDeathEffect.global_position = global_position

#func _on_Hurtbox_invincibility_started():
#	blinkAnimationPlayer.play("Start")

#func _on_Hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")

#func _on_Hitbox_area_entered(_area):
#	state = ATTACK
