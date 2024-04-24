extends Node2D

@export var next_level_path: String

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Detected")
		load_next_level()

func load_next_level():
	print("Load Level Called")
	# To implement
