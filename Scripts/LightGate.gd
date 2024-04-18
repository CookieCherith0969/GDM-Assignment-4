@tool
extends Node2D

@export var gateX = 6
@export var gateY = 4

@onready
var block_scene = preload("res://Scenes/gateBlock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		remove_child(child)
	for x in range(gateX):
		for y in range(gateY):
			var block = block_scene.instantiate()
			add_child(block)
			block.pos = Vector2(x,y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
