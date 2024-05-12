extends Node2D

@export
var removed_vent : Vent
@export
var fake_hives : Array[Node2D]
@export
var wait_time = 2.0
@export
var special_lamp_plant : Node2D

@onready
var glow_light = $GlowLight

func _on_detection_area_body_entered(body):
	if is_instance_of(body, Player):
		glow_light.enabled = true
		body.lock_controls()
		body.exited.connect(on_player_exited)
		removed_vent.queue_free()
		for hive in fake_hives:
			hive.spawn_enemies(2)
		await get_tree().create_timer(wait_time).timeout
		for hive in fake_hives:
			hive.remove_enemies()
			hive.replace_with_real(2)
		body.exited.disconnect(on_player_exited)
		body.free_controls()
		replace_with_real()

func on_player_exited():
	PlayerManager.current_player.lock_controls()

func replace_with_real():
	special_lamp_plant.position = position
	queue_free()
