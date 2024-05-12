extends Area2D

@export
var id = 1

@onready
var sprite = $AnimatedSprite2D
@onready
var button_down = $ButtonDown
@onready
var button_up = $ButtonUp
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("Up")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if is_instance_of(body, Player):
		sprite.play("Down")
		button_down.play()
		PowerManager.increase_power(id)


func _on_body_exited(body):
	if is_instance_of(body, Player):
		sprite.play("Up")
		button_up.play()
		PowerManager.decrease_power(id)
