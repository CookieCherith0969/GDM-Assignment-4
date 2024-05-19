shader_type canvas_item;

uniform float height = 2;
uniform float frequency = 5;
uniform float speed = 2;

void vertex() {
	VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
}