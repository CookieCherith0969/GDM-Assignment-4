extends Area2D

func _on_body_entered(body):
	if is_instance_of(body, Player) and not body.has_battery:
		body.has_battery = true
		SoundManager.play_pickup()
		queue_free()
