@tool
extends PointLight2D

@export
var lights_lightables = true : set = set_lightables
@export
var lights_player = true : set = set_player
@export_range(0.05, 500)
var radius : float = 50 : set = set_radius

@onready
var light_area = $LightArea

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = radius
	lights_lightables = lights_lightables
	lights_player = lights_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_lightables(val : bool):
	lights_lightables = val
	if not is_instance_valid(light_area):
		return
	
	update_mask()

func set_player(val : bool):
	lights_player = val
	if not is_instance_valid(light_area):
		return
	
	update_mask()

func update_mask():
	light_area.ray_mask = 16
	if lights_lightables:
		light_area.ray_mask += 8
	if lights_player:
		light_area.ray_mask += 2

func set_radius(val : float):
	radius = val
	if not is_instance_valid(light_area):
		return
	
	light_area.ray_range = radius
	texture_scale = radius/45


func _on_light_area_target_entered(target):
	if target.has_method("on_lit"):
		target.on_lit(self)


func _on_light_area_target_exited(target):
	if target.has_method("on_unlit"):
		target.on_unlit(self)
