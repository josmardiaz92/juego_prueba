extends Node

var life=100
var score=0
var time:int
var axis:Vector2

func get_axis()->Vector2:
	axis.x=int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	axis.y=int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
