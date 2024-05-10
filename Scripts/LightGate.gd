@tool
extends Node2D

@export var gateSize : Vector2i = Vector2i(6,4) : set = set_size

@onready
var block_scene = preload("res://Scenes/gateBlock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	gateSize = gateSize
	
	#for child in get_children():
	#	remove_child(child)
	#for x in range(gateX):
	#	for y in range(gateY):
	#		var block = block_scene.instantiate()
	#		add_child(block)
	#		block.pos = Vector2(x,y)

func set_size(val : Vector2i):
	gateSize = val
	if !is_instance_valid(block_scene):
		return
	
	if gateSize.x < 1:
		gateSize.x = 1
	if gateSize.y < 1:
		gateSize.y = 1
	
	for child in get_children():
		remove_child(child)
	for x in range(gateSize.x):
		for y in range(gateSize.y):
			var block = block_scene.instantiate()
			add_child(block)
			block.pos = Vector2(x,y)
