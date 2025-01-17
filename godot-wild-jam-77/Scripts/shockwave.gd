class_name Shockwave extends CanvasLayer

@export var shockwave_rect: ColorRect
@export var animation_player: AnimationPlayer

func play_shockwave_at(loc: Vector2):
	var adjusted_loc = Vector2(loc.x / 1920, loc.y / 1080)
	shockwave_rect.material.set_shader_parameter("center", adjusted_loc)
	animation_player.play("shockwave")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	self.queue_free()
