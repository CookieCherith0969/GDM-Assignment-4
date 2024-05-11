extends Node

@onready
var background_music = $BGM
@onready
var ambient = $Ambient
@onready
var death = $Death
@onready
var button = $menuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_music():
	background_music.play()
	ambient.stop()

func start_ambient():
	background_music.stop()
	ambient.play()
	
func play_death():
	death.play()
func menu_button():
	button.play()
