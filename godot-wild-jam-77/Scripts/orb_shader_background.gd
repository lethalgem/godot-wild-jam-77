class_name OrbShaderBackground extends ColorRect

@export var orb_body: OrbBody
var radius: float = 10.0:
	get:
		return radius
	set(new_val):
		size = Vector2(new_val * 2, new_val * 2)
		radius = new_val

func _process(_delta: float) -> void:
	global_position = Vector2(orb_body.position.x - radius, orb_body.position.y - radius)
