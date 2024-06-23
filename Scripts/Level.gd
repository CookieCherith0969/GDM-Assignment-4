extends Node2D

@export
var start_elevator : Elevator
@export
var end_elevator : Elevator

var checkpoints : Array
var current_checkpoint = -1

@export
var data_logs : Array[Node]

func get_start_elevator():
	return start_elevator

func get_end_elevator():
	return end_elevator

func register_checkpoint(checkpoint):
	while checkpoints.size() < checkpoint.checkpoint_id+1:
		checkpoints.append(null)
	checkpoints[checkpoint.checkpoint_id] = checkpoint

func set_logs_read(is_read_array):
	for i in range(is_read_array.size()):
		data_logs[i].is_read = is_read_array[i]

func get_logs_read():
	var is_read_array = []
	for data_log in data_logs:
		is_read_array.append(data_log.is_read)
	return is_read_array
