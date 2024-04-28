@tool
extends StaticBody2D

@export
var power_id := 0
@export
var start_powered = false : set = set_start_powered

@onready
var shape = $CollisionShape2D
@onready
var sprite = $Sprite2D
@onready
var occluder = $LightOccluder2D
var id : int = 0 : set = set_id
var registered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		power_id = power_id
		start_powered = start_powered
	else:
		id = power_id
		if start_powered:
			on_power()

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
	if not is_instance_valid(sprite):
		return
	
	if start_powered:
		sprite.hide()
	else:
		sprite.show()

func on_power():
	shape.set_deferred("disabled", true)
	sprite.hide()
	occluder.hide()

func on_depower():
	shape.set_deferred("disabled", false)
	sprite.show()
	occluder.show()
