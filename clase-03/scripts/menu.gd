extends Control

func _ready() -> void:
	$TextureRect/LineEdit.grab_focus()
	get_tree().paused=false

func _on_exit_pressed() -> void:
	get_tree().quit()
	

func _on_start_pressed() -> void:
	if $TextureRect/LineEdit.text=="":
		$ColorRect.visible=true
		$ColorRect/Button.disabled=false
	else:
		GLOBAL.user_name=$TextureRect/LineEdit.text
		get_tree().change_scene_to_file(("res://scennes/level.tscn"))
		


func _on_button_pressed() -> void:
	$ColorRect.visible=false
	$ColorRect/Button.disabled=true
