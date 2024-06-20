extends StaticBody2D

@export
var power_id : int = 0
var id : int = 0 : set = set_id
@export
var checkpoint_id : int = -1

@export_category("Level changes")
@export
var removed_batteries : Array[Battery]
@export
var emptied_ports : Array[Port]
@export
var filled_ports : Array[Port]


@onready
var door_sprite = $DoorSprite
@onready
var door_collider = $DoorCollider

@onready 
var gate_open = $gateOpen
@onready 
var gate_close = $gateClose
@onready
var light = $InvertedDecoLight

var off_color = Color("c95f08b6")
var on_color = Color("3c9761b6")

var registered = false

func _ready():
	if Engine.is_editor_hint():
		power_id = power_id
	else:
		id = power_id
		LevelManager.current_level.register_checkpoint(self)

func set_id(val : int):
	if not registered:
		id = val
		PowerManager.register_powerable(self, id)
		registered = true
		return
	
	PowerManager.deregister_powerable(self, id)
	id = val
	PowerManager.register_powerable(self, id)

func reset_level():
	AudioServer.set_bus_mute(2,true)
	for battery in removed_batteries:
		battery.queue_free()
	for port in emptied_ports:
		port.has_battery = false
	for port in filled_ports:
		port.has_battery = true
	call_deferred("open_door")

func on_power():
	if LevelManager.current_level.current_checkpoint < checkpoint_id:
		LevelManager.current_level.current_checkpoint = checkpoint_id
	light.color = on_color
	#call_deferred("open_door")

func on_depower():
	light.color = off_color
	#call_deferred("close_door")

func open_door():
	AudioServer.set_bus_mute(2,false)
	gate_open.play()
	door_sprite.hide()
	door_collider.disabled = true

func close_door():
	AudioServer.set_bus_mute(2,false)
	gate_close.play()
	door_sprite.show()
	door_collider.disabled = false

func _on_inside_area_body_exited(body):
	if is_instance_of(body, Player):
		call_deferred("close_door")
