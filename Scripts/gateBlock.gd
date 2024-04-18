@tool
extends StaticBody2D

@onready
var sprite = $Sprite
@onready
var occluder = $LightOccluder2D

@export
var pos : Vector2 : set = set_pos

var num_lights = 0 : set = set_lights
var lit : bool : set = set_lit

var active_colour = Color("#ffffff")
var inactive_colour = Color("#404040")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = sprite.texture.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_pos(new_pos : Vector2):
	if not is_instance_valid(sprite):
		return
	pos = new_pos
	position = pos*8
	sprite.texture.region.position = pos*8

func on_lit():
	num_lights += 1
	
func on_unlit():
	num_lights -= 1

func set_lights(val : int):
	num_lights = val
	if num_lights == 0:
		lit = false
	else:
		lit = true

func set_lit(val : bool):
	if lit == val:
		return
	lit = val
	if lit:
		print_debug("Block lit")
		modulate = inactive_colour
		collision_layer -= 1
		occluder.hide()
	else:
		print_debug("Block unlit")
		modulate = active_colour
		collision_layer += 1
		occluder.show()
	
