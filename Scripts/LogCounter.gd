extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var logs =  LevelManager.prev_data_logs_read
	text = "Data Logs "+str(logs)+"/9"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass