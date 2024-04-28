extends Node

var current_level = null
var current_name = null
@onready
var root = get_tree().root
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = root.get_child(root.get_child_count() - 1)
	current_name = "Tutorial"

func load_level(level_name : String):
	PowerManager.clear_all()
	get_tree().change_scene_to_file("res://Scenes/Levels/"+level_name+".tscn")
	current_name = level_name

func reload_level():
	load_level(current_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
