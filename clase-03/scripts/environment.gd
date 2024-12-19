extends Node2D

func _process(delta: float) -> void:
	parallax_bg(delta)

func parallax_bg(delta_time)->void:
	$sky.scroll_base_offset-=Vector2(1,0)*40*delta_time
	$FarCloud.scroll_base_offset-=Vector2(1,0)*80*delta_time
	$nearCloud.scroll_base_offset-=Vector2(1,0)*120*delta_time
