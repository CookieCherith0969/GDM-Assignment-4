extends Area2D

@export
var has_battery = false : set = set_battery
@export
var id := 0 : set = set_id

var unslotted_sprite = preload("res://Art/PlaceholderArt/Port.png")
var slotted_sprite = preload("res://Art/PlaceholderArt/PortFull.png")

@onready
var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_battery(val : bool):
	var prev_val = has_battery
	has_battery = val
	if not is_instance_valid(sprite):
		return
	
	if has_battery != prev_val:
		if has_battery:
			sprite.texture = slotted_sprite
			PowerManager.increase_power(id)
		else:
			sprite.texture = unslotted_sprite
			PowerManager.decrease_power(id)

func set_id(val : int):
	if has_battery:
		PowerManager.decrease_power(id)
		id = val
		PowerManager.increase_power(id)
	else:
		id = val


func _on_body_entered(body):
	if is_instance_of(body, Player):
		has_battery = true

func _on_body_exited(body):
	if is_instance_of(body, Player):
		has_battery = false
