extends Node

@onready
var background_music = $BGM
@onready
var death = $Death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_music():
	background_music.play()

func stop_music():
	background_music.stop()
	
func play_death():
	death.play()
