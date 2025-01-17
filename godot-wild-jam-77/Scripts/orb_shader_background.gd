class_name OrbShaderBackground extends ColorRect

@export var orb_body: OrbBody
var radius: float = 10.0:
	set(new_val):
		var shader_offset_px = 2
		# b/c it's a rectangle shaded to look like a circle
		size = Vector2(new_val * 2 + shader_offset_px * 2, new_val * 2 + shader_offset_px * 2)
		position = Vector2(-new_val - shader_offset_px, -new_val - shader_offset_px)
		radius = new_val

var orb_color: Color = Color.AQUA:
	set(new_val):
		material.set_shader_parameter("mana_color", new_val)
		#material.set_shader_parameter("border_color", new_val)
		orb_color = new_val
