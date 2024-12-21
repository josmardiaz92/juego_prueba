extends CanvasLayer

func _ready() -> void:
	%restart.disabled=true
	%exit.disabled=true

func _process(delta: float) -> void:
	$MarginContainer/HBoxContainer/username.text = str(GLOBAL.user_name)
	$MarginContainer/HBoxContainer/health.text = "health: " + str(GLOBAL.health)
	$MarginContainer/HBoxContainer/score.text = "score: " + str(GLOBAL.score)


func game_over():
	get_tree().paused=true
	%restart.disabled=false
	%exit.disabled=false
	var tween:Tween=create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect,"modulate",Color(1,1,1,0.8),1.0)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scennes/menu.tscn")
