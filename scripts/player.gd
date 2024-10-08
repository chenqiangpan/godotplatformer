extends CharacterBody2D

#movement
const SPEED = 130.0

#attack
const HITBOX_RIGHT_X = 4.5  # X position of the hitbox when facing right
const HITBOX_LEFT_X = -16.5    # X position of the hitbox when facing left


#animation
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#audio
@onready var audio_jump: AudioStreamPlayer2D = $Audio_Jump
@onready var audio_attack: AudioStreamPlayer2D = $Audio_Attack

#jump
const JUMP_VELOCITY_HIGH = -200.0
const JUMP_VELOCITY_LOW = -150.0
var HOLD_THRESHOLD = 0.3
var press_time = 0.0 
var jump_height = JUMP_VELOCITY_LOW
var is_holding = false
var is_jumping = false

# attack state
var attacking = false
@onready var hitbox_animation: AnimationPlayer = $hitboxAnimation
@onready var hitbox: Area2D = $hitbox


#coyote time
@onready var Coyote_timer: Timer = $Timer

# Direction handling
var last_direction = 1 


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and(is_on_floor() or !Coyote_timer.is_stopped()) :
		_handle_jump()
		
	elif Input.is_action_pressed("jump") and is_holding and is_jumping:
		_handle_hold_jump(delta)
		
	elif Input.is_action_just_released("jump"):
		is_holding = false;	
	

	# gets input direction = -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip the sprite	
	if direction >0:
		animated_sprite.flip_h = false
		last_direction = direction
	elif direction <0:
		animated_sprite.flip_h = true
		last_direction = direction
	
	update_hitbox_position(direction)
	
	#handle attack input 
	if  Input.is_action_just_pressed("Attack") and not attacking:
		attacking = true 
		hitbox_animation.play("hitbox_Anim")
		animated_sprite.play("attack")
		audio_attack.play()
		
	
	#play movement animation if not attack
	if not attacking:
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


	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor && !is_on_floor():
		Coyote_timer.start()
	
	
	
	
	
func _handle_jump():
	velocity.y = JUMP_VELOCITY_LOW
	press_time = 0.0
	is_holding = true
	is_jumping = true
	audio_jump.play()	
	
func _handle_hold_jump(delta):
		press_time += delta
		if press_time < HOLD_THRESHOLD :
			velocity.y = lerp(JUMP_VELOCITY_LOW, JUMP_VELOCITY_HIGH, press_time/HOLD_THRESHOLD )
		else:
			velocity.y = JUMP_VELOCITY_HIGH
			is_holding = false
			is_jumping = false




func _on_timer_timeout() -> void:
	print("coyote is over!")
 # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		attacking = false
		animated_sprite.play("idle") # Replace with function body.

func update_hitbox_position(dir: int):
	if dir == 0:
		dir = last_direction
	hitbox.position.x = HITBOX_RIGHT_X if dir > 0 else HITBOX_LEFT_X
