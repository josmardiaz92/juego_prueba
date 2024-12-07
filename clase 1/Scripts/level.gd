extends Node2D

const SPEED=5
var direction=Vector2(0,0)
var mover=true
@onready var Player=$Player


func _process(_delta: float) -> void:
	if Player.position<=get_viewport_rect().size && mover:
		motion_ctrl()

func motion_ctrl():
	Player.position+=GLOBAL.get_axis()*SPEED


func _on_button_pressed() -> void:
	$Player.modulate=Color(randf(),randf(),randf())


func _on_visibilidad_pressed() -> void:
	if Player.visible:
		Player.visible=false
		mover=false
	else:
		Player.visible=true
		mover=true
		
