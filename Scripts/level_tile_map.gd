@tool
extends TileMap

@export
var visibility_bounds : Rect2i = Rect2i(0,0,0,0) : set = set_bounds
@export
var show_visibility = false : set = set_visibility

@onready
var visible_notifier : VisibleOnScreenNotifier2D = null
@onready
var debug_bounds = $DebugBounds

func _ready():
	if !Engine.is_editor_hint():
		visible_notifier = VisibleOnScreenNotifier2D.new()
		get_parent().add_child.call_deferred(visible_notifier)
		visible_notifier.global_position = global_position
		visible_notifier.screen_entered.connect(_on_screen_entered)
		visible_notifier.screen_exited.connect(_on_screen_exited)
	visibility_bounds = visibility_bounds

func set_bounds(val):
	visibility_bounds = val
	
	if !is_instance_valid(debug_bounds):
		return
	print("set bound")
	debug_bounds.position = visibility_bounds.position*16
	debug_bounds.size = (visibility_bounds.size*16)
	
	if !is_instance_valid(visible_notifier):
		return
	
	visible_notifier.rect = Rect2(visibility_bounds.position*16,visibility_bounds.size*16)

func set_visibility(val):
	show_visibility = val
	
	if !is_instance_valid(debug_bounds):
		return
	
	if show_visibility:
		debug_bounds.show()
	else:
		debug_bounds.hide()

func _on_screen_entered():
	show()
	print_debug("Entered screen")

func _on_screen_exited():
	hide()
	print_debug("Exited screen")
