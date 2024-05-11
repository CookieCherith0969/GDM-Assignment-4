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

@onready
var plant_sound = $PlantSound
var shrink_pitch = 0.7
var grow_pitch = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = sprite.texture.duplicate()

func set_pos(new_pos : Vector2):
	if not is_instance_valid(sprite):
		return
	pos = new_pos
	position = pos*8
	sprite.texture.region.position.x = (int(pos.x)*8)%48
	sprite.texture.region.position.y = (int(pos.y)*8)%32

func on_lit(_lighter):
	num_lights += 1
	
func on_unlit(_lighter):
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
		modulate = inactive_colour
		collision_layer -= 1
		occluder.hide()
		plant_sound.pitch_scale = shrink_pitch
		plant_sound.play()
	else:
		modulate = active_colour
		collision_layer += 1
		occluder.show()
		plant_sound.pitch_scale = grow_pitch
		plant_sound.play()
	
