@tool
extends PointLight2D

@export
var lights_lightables = true : set = set_lightables
@export
var lights_player = true : set = set_player
@export_range(0.05, 500)
var radius : float = 50 : set = set_radius
@export
var power_id : int = 0
var id : int = 0 : set = set_id

@export
var start_powered = true : set = set_start_powered

var registered = false

@onready
var light_area = $LightArea
@onready
var sprite = $Torch4
@onready
var light_on = $LightOn
@onready
var light_off = $LightOff

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		radius = radius
		lights_lightables = lights_lightables
		lights_player = lights_player
		start_powered = start_powered
		power_id = power_id
	else:
		id = power_id
		update_mask()
		if not start_powered:
			on_depower()
		sprite.hide()

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

func set_id(val : int):
	if not registered:
		id = val
		PowerManager.register_powerable(self, id)
		registered = true
		return
	
	PowerManager.deregister_powerable(self, id)
	id = val
	PowerManager.register_powerable(self, id)

func set_start_powered(val : bool):
	start_powered = val
	
	enabled = start_powered

func on_power():
	light_area.active = true
	enabled = true
	light_on.play()

func on_depower():
	light_area.active = false
	enabled = false
	light_off.play()
