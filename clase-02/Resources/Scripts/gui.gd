extends CanvasLayer

var btnPause

func _ready() -> void:
	btnPause=$MarginContainer/HBoxContainer/Pause

func _process(delta: float) -> void:
	$MarginContainer/HBoxContainer/Score.text ="SCORE: " + str(GLOBAL.score)

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_screen.tscn")

func _on_pause_pressed() -> void:
	if get_tree().paused:
		btnPause.text="PAUSE"
		get_tree().paused=false
	else:
		btnPause.text="PLAY"
		get_tree().paused=true
