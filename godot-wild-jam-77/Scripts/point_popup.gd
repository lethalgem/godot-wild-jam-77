class_name PointPopup extends Node2D

@export var point_label: Label
@export var animation_player: AnimationPlayer

var point_value: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_label.text = "+" + str(point_value * Globals.weight_score_multiplier)
	animation_player.play("show")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
