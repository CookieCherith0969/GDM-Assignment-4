extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var total_read = LevelManager.total_logs_read()
	var max_logs = LevelManager.total_max_logs()
	text = "Data Logs "+str(total_read)+"/"+str(max_logs)

