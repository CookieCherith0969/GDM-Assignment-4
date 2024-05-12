extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var logs =  LevelManager.data_logs_read.count(true)
	text = "Data Logs "+str(logs)+"/9"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
