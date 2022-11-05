extends KinematicBody2D
 
const UP = Vector2(0,-1)
var motion = Vector2.ZERO
const MAXSPEED = 160 

const GRAVITY = 20 #Base Gravity
const MAXFALLSPEED = 500 #Max Falling Speed(y - wise)
const JUMPFORCE = 350 #Player Jump Height
const NORMALSPEED = 20 #Walking Speed
#Dash Movement Variables 
const DASHSPEED = 480 #Dash Speed
const DASHLENGTH = 0.1 #Dash Length 
onready var dash = $Dash # Variable for Calling DashTimer Node
var canDash = false #Value if Player can dash or not
#Interaction w/ Movable Block
const BLOCK_SPEED = 150
const PUSH = 15

func _physics_process(delta: float) -> void:
	apply_gravity()
	get_input()

func get_input():
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
	var ACCEL = DASHSPEED if dash.is_dashing() else NORMALSPEED
	#Left & Right Movement
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		$Sprite.flip_h = false
		$AnimationPlayer.play("Run")
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		$Sprite.flip_h = true
		$AnimationPlayer.play("Run")
	else:
		motion.x = lerp(motion.x,0,0.2)
		$AnimationPlayer.play("Idle")
	#Jump Movement
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			motion.y = -JUMPFORCE
		if is_on_wall():
			if motion.y < 0:
				$AnimationPlayer.play("Jumping")
			elif motion.y > 0:
				motion.y = -JUMPFORCE	
	# Dashing Movement
	if is_on_floor():
		canDash = true
	if !is_on_floor():
		canDash = false
	if Input.is_action_just_pressed("dash") and canDash:
		dash.start_dash(DASHLENGTH)

	motion = move_and_slide(motion, Vector2.UP, false, 4, 0.785398, false)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is MovableBlock:
			collision.collider.apply_central_impulse(-collision.normal * PUSH)

func apply_gravity():	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED	

