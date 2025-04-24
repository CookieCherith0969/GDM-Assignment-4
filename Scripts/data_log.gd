extends Area2D

@export_multiline
var contents : String = "[CORRUPTED FILE]"

#@onready
#var paper = $paperSound
@onready
var popup = $Popup
@onready
var sprite = $Sprite2D
@onready
var window_scene = preload("res://Scenes/Utility/text_window.tscn")

var is_read = false : set = set_read

func _on_body_entered(body):
	if is_instance_of(body, Player):
		popup.show()
		GuiManager.show_interact_button()
		body.interacted.connect(on_interact)
		
func _on_body_exited(body):
	if is_instance_of(body, Player):
		popup.hide()
		GuiManager.hide_interact_button()
		body.interacted.disconnect(on_interact)

func on_interact(player):
	#paper.play()
	#await get_tree().create_timer(0.15).timeout
	GuiManager.show_window(contents)
	player.lock_controls()
	is_read = true


func set_read(val : bool):
	is_read = val
	
	if is_read:
		sprite.play("Off")
	else:
		sprite.play("On")
