extends Node2D

@onready
var barrier = $StaticBody2D

# Signal to listen for player entering the door's area
func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))

# Callback function when player enters the Area2D
func _on_Area2D_body_entered(body):
	if body.has_method("check_has_key") and body.check_has_key():
		body.set_key(false)
		queue_free()

