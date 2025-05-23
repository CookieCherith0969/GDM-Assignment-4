@tool
extends Area2D
class_name Port

@export
var start_with_battery = false : set = set_start_battery
var has_battery = false : set = set_battery
@export
var id := 1 : set = set_id

var editor_power = 0

@onready
var battery_sprite = $BatterySprite
@onready
var popup = $Popup
@onready
var need_battery = $NeedBattery
@onready
var sprite = $Sprite2D

@onready
var off_sprite = preload("res://Art/PlaceholderArt/PortOff.png")
@onready
var on_sprite = preload("res://Art/PlaceholderArt/PortOn.png")
@onready
var left_light = $LeftLight 
@onready
var right_light = $RightLight
var off_color = Color("d22836")
var on_color = Color("3dce32")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		start_with_battery = start_with_battery
	else:
		has_battery = start_with_battery

func set_start_battery(val : bool):
	start_with_battery = val
	if not is_instance_valid(battery_sprite):
		return
	
	battery_sprite.visible = start_with_battery

func set_battery(val : bool):
	var prev_val = has_battery
	has_battery = val
	
	if has_battery != prev_val:
		if has_battery:
			battery_sprite.show()
			sprite.texture = on_sprite
			left_light.color = on_color
			right_light.color = on_color
			PowerManager.increase_power(id)
		else:
			battery_sprite.hide()
			sprite.texture = off_sprite
			left_light.color = off_color
			right_light.color = off_color
			PowerManager.decrease_power(id)

func set_id(val : int):
	if val < 1:
		return
	if has_battery:
		PowerManager.decrease_power(id)
		id = val
		PowerManager.increase_power(id)
	else:
		id = val


func _on_body_entered(body):
	if is_instance_of(body, Player):
		popup.show()
		GuiManager.show_interact_button()
		body.interacted.connect(on_interact)
		
func _on_body_exited(body):
	if is_instance_of(body, Player):
		popup.hide()
		GuiManager.hide_interact_button()
		need_battery.hide()
		body.interacted.disconnect(on_interact)
	
func on_interact(player):
	if player.has_battery and not has_battery:
		player.has_battery = false
		has_battery = true
	elif not player.has_battery and has_battery:
		player.has_battery = true
		has_battery = false
	elif not player.has_battery and not has_battery:
		popup.hide()
		need_battery.show()


