extends CharacterBody2D
class_name Enemy

@export_group("Config")

@export_group("Options")
@export var health:int=1
@export var score:int=100

@export_group("Motion")
@export var speed:int=32
@export var gravity:int=16

var direction:int=-1

func _process(_delta):
	if health>0:
		motion_ctrl()

func motion_ctrl()->void:
	$AnimatedSprite2D.scale.x = -direction
	
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction*=-1
	velocity.x=direction*speed
	velocity.y+=gravity
	move_and_slide()
	
func damage_ctrl():
	health-=1
	$setings/AudioStreamPlayer2D.play()
	if health<=0:
		$AnimatedSprite2D.set_animation("dead")
		$AnimatedSprite2D.play()
		$CollisionShape2D.set_deferred("disabled",true)
		gravity=0
		GLOBAL.score+=score
		if GLOBAL.score>=1000:
			GLOBAL.new_life()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation=="dead":
		GLOBAL.enemy_death=true
		queue_free()
		

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Player and health>0:
		body.damage_ctrl()
