class_name Game extends Node

@export_group("Game Settings")
@export var initial_goal_weight: float = 100 ## weight BEFORE global weight multiplier applied
@export var goal_exp_factor: float = 2.0 ## Exponent for how rapidly the score required grows

@export_group("Obj references")
@export var orb_manager: OrbManager
@export var scale: Scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_scale_goal_weight_achieved() -> void:
	pass # Replace with function body.
