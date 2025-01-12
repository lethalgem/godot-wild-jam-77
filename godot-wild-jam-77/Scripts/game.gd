class_name Game extends Node

@export_group("Game Settings")
@export var initial_goal_weight: float = 10 ## weight BEFORE global weight multiplier applied
@export var goal_exp_factor: float = 1.1 ## Exponent for how rapidly the score required grows
@export var initial_turn_limit: int = 10
@export var turn_limit_increase: int = 10

@export_group("Obj references")
@export var orb_manager: OrbManager
@export var scale: Scale
@export var turn_limit_label: Label
@export var weight_threshold_label: Label
@export var weight_label: Label

var turn_limit: int:
	get:
		return turn_limit
	set(new_val):
		turn_limit_label.text = "Remaining: " + str(new_val)
		orb_manager.spawn_limit = new_val
		turn_limit = new_val

var weight_threshold: float:
	get:
		return weight_threshold
	set(new_val):
		weight_threshold_label.text = "/ " + str(int(scale.goal_weight))
		weight_threshold = new_val

var current_weight: float:
	get:
		return current_weight
	set(new_val):
		weight_label.text = str(int(new_val))
		current_weight = new_val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.goal_weight = initial_goal_weight * Globals.weight_score_multiplier
	weight_threshold = initial_goal_weight * Globals.weight_score_multiplier
	orb_manager.spawn_limit = initial_turn_limit
	turn_limit = initial_turn_limit
	current_weight = 0

func _on_scale_goal_weight_achieved() -> void:
	pass # Replace with function body.


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/audio_menu.tscn")
	scale.goal_weight = scale.goal_weight ** goal_exp_factor
	weight_threshold = scale.goal_weight
	turn_limit = turn_limit_increase
	
func _on_orb_manager_orb_dropped() -> void:
	if turn_limit == 0:
		print("Game Over")
	else:
		turn_limit -= 1

func _on_scale_updated_weight(weight: float) -> void:
	current_weight = weight
