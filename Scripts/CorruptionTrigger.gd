extends Area2D

@export
var activated_vines : Array[Node]

func _on_body_entered(body):
	if is_instance_of(body, Player):
		body.lock_controls()
		body.light_on = false
		activated_vines[0].set_collision_layer_value(1, true)
		#var glow_light = body.get_node("GlowLight")
		for i in range(5):
			await get_tree().create_timer(1.3).timeout
			body.light_on = !body.light_on
			activated_vines[int(i)/2].show()
		await get_tree().create_timer(1.3).timeout
		body.light_on = false
		body.glow_light.enabled = false
		await get_tree().create_timer(2).timeout
		body.light_on = true
		body.corrupted = true
		body.glow_light.enabled = true
		body.moving_up = false
		activated_vines[1].z_index = 0
		activated_vines[2].z_index = 0
		await get_tree().create_timer(3).timeout
		body.light_on = false
		body.free_controls()
		queue_free()
