extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY_HIGH = -200.0
const JUMP_VELOCITY_LOW = -150.0
var HOLD_THRESHOLD = 0.3
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var press_time = 0.0 
var jump_height = JUMP_VELOCITY_LOW
var is_holding = false
var is_jumping = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY_LOW
		press_time = 0.0
		is_holding = true
		is_jumping = true
		audio_stream_player.play()
		
	elif Input.is_action_pressed("jump") and is_holding and is_jumping:
		press_time += delta
		if press_time < HOLD_THRESHOLD :
			velocity.y = lerp(JUMP_VELOCITY_LOW, JUMP_VELOCITY_HIGH, press_time/HOLD_THRESHOLD )
		else:
			velocity.y = JUMP_VELOCITY_HIGH
			is_holding = false
			is_jumping = false
		
	elif Input.is_action_just_released("jump"):
		is_holding = false;	
	
	# gets input direction = -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip the sprite
	
	if direction >0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h = true
		
	#play animation
	if is_on_floor():	
		
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
