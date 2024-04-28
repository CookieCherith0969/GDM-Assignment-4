extends Node2D

# Signal to listen for player entering the door's area
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("check_has_key") and body.check_has_key():
		body.set_key(false)
		queue_free()
