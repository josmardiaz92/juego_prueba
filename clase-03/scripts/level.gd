extends Node2D

@export var enemy:PackedScene

func _ready():
	get_tree().paused = false
	GLOBAL.can_climb = false
	GLOBAL.score = 0
	GLOBAL.health = 2
	
func _process(delta: float) -> void:
	$Settings/Path2D/PathFollow2D.set_progress($Settings/Path2D/PathFollow2D.get_progress() + 80 * delta)

func _on_stairs_body_entered(body: Node2D) -> void:
	if body is Player:
		GLOBAL.can_climb = true

func _on_stairs_body_exited(body: Node2D) -> void:
	if body is Player:
		GLOBAL.can_climb = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($Instructions, "modulate", Color(0, 0, 0, 0), 1.0)
	tween.tween_callback($Instructions.queue_free)


func _on_respawn_timeout() -> void:
	if GLOBAL.enemy_death:
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = $Settings/Path2D/PathFollow2D.global_position
		add_child(enemy_instance)
		GLOBAL.enemy_death = false
