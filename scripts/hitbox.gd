extends Area2D                                                                                                                           



@onready var audio_hit: AudioStreamPlayer2D = $hit



func _on_body_entered(body: Node2D) -> void:
	print("hit enemy: ", body.name)
	audio_hit.play()	
	body._handle_death()
