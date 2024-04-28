extends Node2D

signal failed_open

# Signal to listen for player entering the door's area
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("check_has_key"):
		if body.check_has_key():
			body.set_key(false)
			queue_free()
		else:
			failed_open.emit()
