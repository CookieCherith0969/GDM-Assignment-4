extends Area2D

@onready var pickup = $pickup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if is_instance_of(body, Player) and not body.has_battery:
		body.has_battery = true
		pickup.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
