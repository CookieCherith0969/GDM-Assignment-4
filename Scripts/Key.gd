extends Node2D
@onready var pick_up = $pickUp

@onready
var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("KeyIdle")

func _on_body_entered(body):
	if body.has_method("check_has_key") and not body.check_has_key():
		body.set_key(true)
		pick_up.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
