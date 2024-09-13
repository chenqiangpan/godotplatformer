extends CharacterBody2D

const SPEED = 60

var direction = 1
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $killzone
@onready var killzone_collision: CollisionShape2D = $killzone/CollisionShape2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	
	
	position.x += direction * SPEED * delta
	
func _handle_death():
	killzone_collision.disabled = true
	animated_sprite_2d.play("death")		
	direction = 0	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		queue_free()
# Replace with function body.
