extends Area2D

const SPEED=592
var direction=Vector2.ZERO

func _process(delta: float) -> void:
	global_position+=SPEED*delta*direction


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.damage_ctrl()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
