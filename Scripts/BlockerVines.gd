@tool
extends StaticBody2D

@export
var size : Vector2i = Vector2i(16,16) : set = set_size

@onready
var shape = $CollisionShape2D
@onready
var texture = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	shape.shape = RectangleShape2D.new()
	size = size

func set_size(val : Vector2i):
	size = val
	if size.x < 8:
		size.x = 8
	if size.y < 16:
		size.y = 16
	
	if not is_instance_valid(shape):
		return
	
	shape.shape.size = size
	shape.position = Vector2(size)/2
	texture.size = size
