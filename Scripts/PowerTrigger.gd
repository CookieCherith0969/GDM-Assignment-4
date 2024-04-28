extends Area2D

signal trigger


func _on_body_entered(body):
	if is_instance_of(body, Player) and not PowerManager.is_powered(1):
		trigger.emit()
