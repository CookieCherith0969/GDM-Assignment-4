extends Area2D

@export
var id = 1

@onready
var sprite = $AnimatedSprite2D
@onready
var button_down = $ButtonDown

var is_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("Up")


func _on_body_entered(body):
	if !is_down:
		is_down = true
		sprite.play("Down")
		button_down.play()
		PowerManager.increase_power(id)
