extends Node2D

var apple_position : Vector2i
var rock_positions
var snake_body=[Vector2i(5,10),Vector2i(4,10),Vector2i(3,10)]

func _ready() -> void:
	apple_position=place_apple()
	rock_positions=[place_rock()]
	draw_rocks()
	draw_apple()
	draw_snake()
	
func place_apple()-> Vector2i:
	randomize()
	var x : int=randi()%25
	var y : int=randi()%20
	return Vector2i(x,y)
	
func place_rock()-> Vector2i:
	randomize()
	var x : int=randi()%25
	var y : int=randi()%20
	return Vector2i(x,y)

func draw_apple()->void:
	$SnakeTile.set_cell(0,Vector2i(apple_position),0,Vector2i(0,0))

func draw_rocks()->void:
	for rock in rock_positions:
		$SnakeTile.set_cell(0,Vector2i(rock),2,Vector2i(0,0))

func draw_snake():
	for block in snake_body:
		$SnakeTile.set_cell(0,Vector2i(block),1,Vector2i(7,0))
