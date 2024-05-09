class_name Vent
extends Area2D

@export
var target : Vent

@onready
var popup = $Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if is_instance_of(body, Player):
		popup.show()
		body.interacted.connect(on_interact)


func _on_body_exited(body):
	if is_instance_of(body, Player):
		popup.hide()
		body.interacted.disconnect(on_interact)

func on_interact(player):
	if is_instance_valid(target):
		player.position = target.position
