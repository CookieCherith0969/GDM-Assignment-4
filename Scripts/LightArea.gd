@tool
extends Node2D

@export_range(0,360)
var angle : float = 360 : set = set_angle
@export_range(2,200)
var num_rays : int = 5 : set = set_rays
@export_range(0.05, 500)
var ray_range : float = 20 : set = set_range
@export
var active = true : set = set_active
@export
var hit_from_inside = false : set = set_inside

@onready
var blockable_area = $BlockableArea

# Called when the node enters the scene tree for the first time.
func _ready():
	active = active
	angle = angle
	num_rays = num_rays
	ray_range = ray_range
	hit_from_inside = hit_from_inside
	
	blockable_area.ray_mask = 8

func set_angle(val : float):
	angle = val
	
	if not is_instance_valid(blockable_area):
		return
	
	blockable_area.angle = val
	

func set_rays(val : int):
	num_rays = val
	
	if not is_instance_valid(blockable_area):
		return
		
	blockable_area.num_rays = val
	
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

func _on_blockable_area_target_entered(target):
	target.on_lit()

func _on_blockable_area_target_exited(target):
	target.on_unlit()
