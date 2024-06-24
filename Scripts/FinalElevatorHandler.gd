extends Node

@export
var final_elevator : Node2D

var log_read = false

func _ready():
	GuiManager.window_closed.connect(_on_window_closed)
	
func _on_window_closed():
	log_read = true

func _on_body_entered(body):
	if !log_read:
		return
	if is_instance_of(body, Player):
		final_elevator.force_next()
