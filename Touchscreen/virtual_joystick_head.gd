@tool
extends TouchScreenButton

var head_radius: float = 8.0:
	set(value):
		head_radius = value
		queue_redraw()
var head_color: Color = Color.BLACK:
	set(value):
		head_color = value
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO,head_radius,head_color)
