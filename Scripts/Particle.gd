extends Sprite2D

var velocity := Vector2(0,0)
var speed = 60
var conservation = 0.95
var randomness = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity*speed*delta
	velocity *= conservation
	velocity += Vector2(randomness,0).rotated(randf_range(0,2*PI))*delta
	
	if velocity.x < 0:
		flip_h = false
	else:
		flip_h = true
