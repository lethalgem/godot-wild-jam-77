class_name ShockwaveRect extends ColorRect

@export var animation_player: AnimationPlayer

func play_shockwave_at(loc: Vector2):
	var adjusted_loc = Vector2(loc.x / 1920, loc.y / 1080)
	material.set_shader_parameter("center", adjusted_loc)
	animation_player.play("shockwave")
