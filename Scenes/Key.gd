extends Node2D

@onready
var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("KeyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("check_has_key") and not body.check_has_key():
		body.set_key(true)
		queue_free()
