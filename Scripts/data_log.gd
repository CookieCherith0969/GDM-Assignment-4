extends Area2D

@export_multiline
var contents : String = "[CORRUPTED FILE]"

@onready
var popup = $Popup
@onready
var sprite = $Sprite2D
@onready
var window_scene = preload("res://Scenes/text_window.tscn")

var is_read = false : set = set_read


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if is_instance_of(body, Player):
		popup.show()
		body.interacted.connect(on_interact)
		
func _on_body_exited(body):
	if is_instance_of(body, Player):
		popup.hide()
		body.interacted.disconnect(on_interact)

func on_interact(player):
	GuiManager.show_window(contents)
	player.lock_controls()
	is_read = true

func set_read(val : bool):
	is_read = val
	
	if is_read:
		sprite.play("read")
	else:
		sprite.play("default")
