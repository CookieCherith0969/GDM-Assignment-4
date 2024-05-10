@tool
extends PointLight2D

@export_range(0.05, 500)
var radius : float = 50 : set = set_radius
@export
var power_id : int = 0
var id : int = 0 : set = set_id

var registered = false

@onready
var sprite = $Torch4

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		radius = radius
		power_id = power_id
	else:
		id = power_id
		sprite.hide()

func set_radius(val : float):
	radius = val
	
	texture_scale = radius/45

func set_id(val : int):
	if not registered:
		id = val
		PowerManager.register_powerable(self, id)
		registered = true
		return
	
	PowerManager.deregister_powerable(self, id)
	id = val
	PowerManager.register_powerable(self, id)

func on_power():
	enabled = true

func on_depower():
	enabled = false
