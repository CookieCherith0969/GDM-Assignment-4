extends Area2D




func _on_body_entered(body):
	if is_instance_of(body, Player):
		body.lock_controls()
		body.light_on = false
		var glow_light = body.get_node("GlowLight")
		for i in range(5):
			await get_tree().create_timer(1).timeout
			body.light_on = !body.light_on
		body.corrupted = true
		await get_tree().create_timer(3).timeout
		body.light_on = false
		body.free_controls()
		queue_free()
