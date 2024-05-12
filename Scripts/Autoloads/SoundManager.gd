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
