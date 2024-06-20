extends Node2D

@export
var start_elevator : Elevator
@export
var end_elevator : Elevator

var checkpoints : Array
var current_checkpoint = -1

func get_start_elevator():
	return start_elevator

func get_end_elevator():
	return end_elevator

func register_checkpoint(checkpoint):
	while checkpoints.size() < checkpoint.checkpoint_id+1:
		checkpoints.append(null)
	checkpoints[checkpoint.checkpoint_id] = checkpoint
