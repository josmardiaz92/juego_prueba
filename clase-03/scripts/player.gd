extends CharacterBody2D
class_name Player

var is_on_ground:bool=false
var is_climbing:bool=false
var deadth:bool=false
var shot_spawn:Vector2
var can_shot:bool=true

@export_category("Config")
@export_group("Required references")
@export var gui:CanvasLayer
@export var shot:PackedScene

@export_group("motion")
@export var speed:int=128
@export var gravity:int=16
@export var jump_force:int=364

func _process(delta: float) -> void:
	is_on_ground=is_on_floor()
	match deadth:
		true:
			deadth_ctrl();
		false:
			motion_ctrl();
			if velocity.y>=2000:
				gui.game_over()
			if not GLOBAL.can_climb:
				is_climbing=false

func _input(event: InputEvent) -> void:
	if not deadth and is_on_ground and event.is_action_pressed("ui_accept"):
		jump_ctrl(1)
	if event.is_action_pressed("ui_select"):
		shot_ctrl()
	if is_on_ground and Input.is_action_just_pressed("ui_right") or is_on_ground and Input.is_action_just_pressed("ui_left"):
		$Node/footstepSound.play()
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		$Node/footstepSound.stop()
	
func shot_ctrl()->void:
	if can_shot:
		$Alien/flash.play()
		$Node/fireSound.play()
		var shot_instance=shot.instantiate()
		shot_instance.global_position=$Alien/Marker2D.global_position
		shot_instance.scale=%Alien.scale
		shot_instance.direction=Vector2(%Alien.scale.x,0)
		can_shot=false
		get_parent().add_child(shot_instance)
		$Node/ShortTimer.start()

func deadth_ctrl()->void:
	velocity.x=0
	velocity.y+=gravity
	GLOBAL.is_invincible=false
	move_and_slide()
	
func motion_ctrl()->void:
	#movimiento
	if GLOBAL.can_climb and GLOBAL.get_axis().y!=0:
		climb()
	elif GLOBAL.get_axis().x!=0:
		%Alien.scale.x=GLOBAL.get_axis().x
	velocity.y+=gravity
	velocity.x=GLOBAL.get_axis().x*speed
	move_and_slide() #cada vez que se hace algo para movimiento se coloca esto al final para que velocity sirva
	
	#animaciones
	match GLOBAL.can_climb and is_climbing:
		false:
			match is_on_ground:
				true:
					if GLOBAL.get_axis().x!=0:
						%Alien.set_animation("walking")
						%Alien.play()
					else:
						%Alien.set_animation("idle")
						%Alien.play()
				false:
					if velocity.y<0:
						%Alien.set_animation("jump")
						$Node/jumpSound.play()
					else:
						pass
		true:
			match GLOBAL.get_axis().x!=0:
				true:
					%Alien.set_animation("walking")
					%Alien.play()
				false:
					if GLOBAL.get_axis().y!=0:
						%Alien.set_animation("climb")
						%Alien.play()
					elif GLOBAL.get_axis().y==0:
						%Alien.stop()
	
	
func jump_ctrl(power:float)->void:
	velocity.y=-jump_force*power

func climb()->void:
	is_climbing=true
	velocity.y=GLOBAL.get_axis().y*-speed
	move_and_slide()

func damage_ctrl():
	if GLOBAL.is_invincible==false:
		$Node/DamageTimer.start()
		$Node/damageSound.play()
		if GLOBAL.health>0:
			GLOBAL.health-=1
			var tween:Tween=create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(%Alien,"modulate",Color(0,0,0,0),0.2)
			tween.tween_property(%Alien,"modulate",Color(1,1,1,1),0.2)
			tween.tween_property(%Alien,"modulate",Color(0,0,0,0),0.2)
			tween.tween_property(%Alien,"modulate",Color(1,1,1,1),0.2)
			tween.tween_property(%Alien,"modulate",Color(0,0,0,0),0.2)
			tween.tween_property(%Alien,"modulate",Color(1,1,1,1),0.2)
			GLOBAL.is_invincible=true
		
		if GLOBAL.health<=0:
			deadth=true
			%Alien.play("dead")
			


func _on_short_timer_timeout() -> void:
	can_shot=true


func _on_damage_timer_timeout() -> void:
	GLOBAL.is_invincible=false


func _on_alien_animation_finished() -> void:
	if %Alien.animation=="dead":
		%Alien.stop()
		gui.game_over()
