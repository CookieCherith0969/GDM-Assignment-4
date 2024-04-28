@tool
extends Node2D

@export_range(0,360)
var angle : float = 360 : set = set_angle
@export_range(0.05, 500)
var ray_range : float = 20 : set = set_range
@export_range(1,16)
var max_gap : float = 6.0 : set = set_gap
@export
var active = true : set = set_active
@export
var hit_from_inside = false : set = set_inside

@export
var lighter : Node

@onready
var blockable_area = $BlockableArea

# Called when the node enters the scene tree for the first time.
func _ready():
	active = active
	angle = angle
	ray_range = ray_range
	hit_from_inside = hit_from_inside
	max_gap = max_gap
	
	blockable_area.ray_mask = 24

func set_angle(val : float):
	angle = val
	
	if not is_instance_valid(blockable_area):
		return
	
	blockable_area.angle = val
	
func set_range(val : float):
	ray_range = val
	
	if not is_instance_valid(blockable_area):
		return
		
	blockable_area.ray_range = val

func set_active(val : bool):
	active = val
	
	if not is_instance_valid(blockable_area):
		return
	
	blockable_area.active = val

func set_inside(val : bool):
	hit_from_inside = val
	
	if not is_instance_valid(blockable_area):
		return
	
	blockable_area.hit_from_inside = val

func set_gap(val : float):
	max_gap = val
	
	if not is_instance_valid(blockable_area):
		return
	
	blockable_area.max_gap = max_gap

func _on_blockable_area_target_entered(target):
	if not lighter:
		target.on_lit(self)
	else:
		target.on_lit(lighter)

func _on_blockable_area_target_exited(target):
	if not lighter:
		target.on_unlit(self)
	else:
		target.on_unlit(lighter)
