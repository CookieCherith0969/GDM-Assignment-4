extends Sprite2D

var scout_scene = preload("res://Scenes/enemy.tscn")

@export_range(0,5)
var scout_num : int = 1 : set = set_scout_num
var scouts : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	scout_num = scout_num

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_scout_num(val : int):
	scout_num = val
	
	if scout_num < 0:
		scout_num = 0
	
	while scout_num > scouts.size():
		var new_scout = scout_scene.instantiate()
		new_scout.home_hive = self
		new_scout.position.x = randf_range(-5,5)
		new_scout.position.y = randf_range(-5,5)
		scouts.append(new_scout)
		add_child(new_scout)
	
	while scout_num < scouts.size():
		remove_child(scouts.back())
		scouts.pop_back()
