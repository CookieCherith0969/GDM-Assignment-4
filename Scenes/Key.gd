extends Node2D

@onready
var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Keys")
	sprite.play("KeyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
