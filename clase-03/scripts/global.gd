extends Node


var score : int = 0
var health : int = 2
var axis : Vector2
var direction : int = 1
var can_climb : bool = false
var is_invincible : bool = false
var enemy_death : bool = false
var user_name : String


func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized() if axis != Vector2() else Vector2()


func new_life():
	score -= 1000
	health += 1
