extends Sprite2D

@onready
var fake_enemy_scene = preload("res://Scenes/fake_enemy.tscn")
@onready
var real_hive_scene = preload("res://Scenes/hive.tscn")

func spawn_enemies(num : int):
	for i in range(num):
		var new_scout = fake_enemy_scene.instantiate()
		new_scout.position.x = randf_range(-5,5)
		new_scout.position.y = randf_range(-5,5)
		add_child(new_scout)

func remove_enemies():
	for child in get_children():
		child.queue_free()

func replace_with_real(scout_num : int):
	var new_hive = real_hive_scene.instantiate()
	new_hive.position = position
	new_hive.scout_num = scout_num
	get_parent().add_child(new_hive)
	queue_free()
