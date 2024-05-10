extends Node2D

@export var next_level_name: String

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		#print_debug("Player Detected")
		call_deferred("load_next_level")

func load_next_level():
	#print_debug("Load Level Called")
	LevelManager.load_level(next_level_name)
