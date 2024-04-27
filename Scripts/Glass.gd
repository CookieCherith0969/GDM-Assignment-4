@tool
extends Node2D

@export
var size : Vector2i = Vector2i(16,16) : set = set_size

@onready
var collider = $StaticBody2D/CollisionShape2D
@onready
var sprite = $SpriteRect

# Called when the node enters the scene tree for the first time.
func _ready():
	collider.shape = RectangleShape2D.new()
	
	size = size

func set_size(val : Vector2i):
	if not is_instance_valid(sprite):
		return
	
	size = val
	
	if size.x < 2:
		size.x = 2
		notify_property_list_changed()
	if size.y < 2:
		size.y = 2
		notify_property_list_changed()
	
	collider.shape.size = size
	collider.position = Vector2(size)/2
	
	sprite.size = size
