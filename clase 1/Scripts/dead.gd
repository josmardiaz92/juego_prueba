extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.scale=Vector2(.5,.5)




func _on_body_exited(body: Node2D) -> void:
	if body is hola:
		body.scale=body.scale*2
