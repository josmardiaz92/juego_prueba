extends Node2D

const SPEED=5
var direction=Vector2(0,0)
@onready var Player=$Player


func _process(_delta: float) -> void:
	if Player.position<=get_viewport_rect().size:
		motion_ctrl()

func motion_ctrl():
	if Input.is_action_pressed("ui_down"):
		$Player.position.y += SPEED
	elif Input.is_action_pressed("ui_up"):
		$Player.position.y -= SPEED
	elif Input.is_action_pressed("ui_right"):
		$Player.position.x += SPEED
	elif Input.is_action_pressed("ui_left"):
		$Player.position.x -= SPEED


func _on_button_pressed() -> void:
	$Player.modulate=Color(randf(),randf(),randf())
