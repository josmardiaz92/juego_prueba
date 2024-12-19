extends Node2D

var apple_position : Vector2i
var rock_positions
var snake_body
var snake_direction : Vector2i 
var add_apple : bool = false

const APPLE=0
const SNAKE=1
const ROCK=2

func _ready() -> void:
	$Timer.wait_time=0.2
	GLOBAL.score=0
	snake_body=[Vector2i(5,10),Vector2i(4,10),Vector2i(3,10)]
	snake_direction=Vector2i(1,0)
	apple_position=place_apple()
	rock_positions=[place_rock()]
	
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
	$SnakeTile.set_cell(0,Vector2i())
	for block_index in snake_body.size():
		var block = snake_body[block_index]
		if block_index==0:
			var head_dir=relation2(snake_body[block_index],snake_body[block_index+1])
			match head_dir:
				'righ':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(2,0))
				'left':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(3,1))
				'up':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(2,1))
				'down':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(3,0))
		elif block_index==snake_body.size()-1:
			var tail_dir=relation2(snake_body[block_index],snake_body[block_index-1])
			match tail_dir:
				'righ':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(1,0))
				'left':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(0,0))
				'up':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(0,1))
				'down':
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(1,1))
		else:
			var previous_block=snake_body[block_index+1]-block
			var next_block=snake_body[block_index-1]-block
			if previous_block.x==next_block.x:
				$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(4,1))
			elif previous_block.y==next_block.y:
				$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(4,0))
			else:
				if previous_block.x==-1 and next_block.y==-1 or next_block.x==-1 and previous_block.y==-1:
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(6,1))
				elif previous_block.x==1 and next_block.y==1 or next_block.x==1 and previous_block.y==1:
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(5,0))
				elif previous_block.x==-1 and next_block.y==1 or next_block.x==-1 and previous_block.y==1:
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(6,0))
				elif previous_block.x==1 and next_block.y==-1 or next_block.x==1 and previous_block.y==-1:
					$SnakeTile.set_cell(0,Vector2i(block),SNAKE,Vector2i(5,1))
		
func relation2(first_block:Vector2i,second_block:Vector2i):
	var block_relation=second_block-first_block
	if block_relation==Vector2i(-1,0): return 'righ'
	if block_relation==Vector2i(1,0): return 'left'
	if block_relation==Vector2i(0,1): return 'up'
	if block_relation==Vector2i(0,-1): return 'down'

func mover_snake():
	if add_apple:
		delete_tiles(1)
		var body_copy=snake_body.slice(0,snake_body.size())
		var new_head=body_copy[0]+snake_direction
		body_copy.insert(0,new_head)
		snake_body=body_copy
		add_apple=false
	else:
		delete_tiles(1)
		var body_copy=snake_body.slice(0,snake_body.size()-1)
		var new_head=body_copy[0]+snake_direction
		body_copy.insert(0,new_head)
		snake_body=body_copy
	
func delete_tiles(id : int) -> void:
	var cells=$SnakeTile.get_used_cells_by_id(0,id)
	for cell in cells:
		$SnakeTile.set_cell(0,Vector2i(cell),-1)

func _on_timer_timeout() -> void:
	mover_snake()
	check_apple_eaten()
	draw_snake()
	draw_apple()
	draw_rocks()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up") and snake_direction != Vector2i(0,1):
		snake_direction=Vector2i(0,-1)
	if Input.is_action_just_pressed("ui_down") and not  snake_direction == Vector2i(0,-1):
		snake_direction=Vector2i(0,1)
	if Input.is_action_just_pressed("ui_left") and not snake_direction == Vector2i(1,0):
		snake_direction=Vector2i(-1,0)
	if Input.is_action_just_pressed("ui_right") and not snake_direction == Vector2i(-1,0):
		snake_direction=Vector2i(1,0)
		
func check_apple_eaten()->void:
	if apple_position==snake_body[0]:
		apple_position=place_apple()
		$audios.go_player("crunch")
		GLOBAL.score+=1
		add_apple=true
		if GLOBAL.score %3 == 0:
			rock_positions.append(place_rock())
		if GLOBAL.score %5==0 and $Timer.wait_time > 0.05:
			$Timer.wait_time-=0.02

func check_game_over()->void:
	var head=snake_body[0]
	if head.x > 24 or head.x < 0 or head.y > 19 or head.y < 0:
		reset()
	if head in rock_positions:
		reset()
	for block in snake_body.slice(1,snake_body.size()):
		if block==head:
			reset()
		
func reset()->void:
	$audios.go_player("loser")
	delete_tiles(SNAKE)
	delete_tiles(APPLE)
	for rock in rock_positions:
		delete_tiles(ROCK)
	_ready()

func _process(delta: float) -> void:
	check_game_over()
	
