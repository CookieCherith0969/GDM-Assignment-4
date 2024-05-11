extends Node

@onready
var background_music = $BGM
@onready
var ambient = $Ambient
@onready
var death = $Death
@onready
var button = $menuButton
@onready
var pickup = $pickup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_music():
	ambient.stop()
	if !background_music.playing:
		background_music.play()
	

func start_ambient():
	background_music.stop()
	if !ambient.playing:
		ambient.play()
	
func play_death():
	death.play()

func menu_button():
	button.play()

func play_pickup():
	pickup.play()
