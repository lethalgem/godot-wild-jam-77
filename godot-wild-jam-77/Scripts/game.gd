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
@export var weight_threshold_label: AnimatedLabel
@export var weight_label: AnimatedLabel
@export var shockwave_rect: ShockwaveRect
@export var game_camera: GameCamera
@export var game_over_timer: Timer

const end_game = preload("res://scenes/endgame.tscn")

var turn_limit: int:
	get:
		return turn_limit
	set(new_val):
		turn_limit_label.text = "Remaining: " + str(new_val if (new_val > 0) else 0)
		orb_manager.spawn_limit = new_val
		turn_limit = new_val

var weight_threshold: float:
	get:
		return weight_threshold
	set(new_val):
		weight_threshold_label.update_text(str(int(scale.goal_weight)))
		weight_threshold = new_val

var current_weight: float:
	get:
		return current_weight
	set(new_val):
		weight_label.update_text(str(int(new_val)))
		current_weight = new_val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.goal_weight = initial_goal_weight * Globals.weight_score_multiplier
	weight_threshold = initial_goal_weight * Globals.weight_score_multiplier
	orb_manager.spawn_limit = initial_turn_limit
	turn_limit = initial_turn_limit
	current_weight = 0
	weight_threshold_label.set_static_text("/ ")

func _on_scale_goal_weight_achieved() -> void:
	scale.goal_weight = scale.goal_weight ** goal_exp_factor
	weight_threshold = scale.goal_weight
	turn_limit = turn_limit_increase

func _on_orb_manager_orb_dropped() -> void:
	if turn_limit == 0:
		game_over_timer.start()
	turn_limit -= 1

func _on_scale_updated_weight(weight: float) -> void:
	current_weight = weight


func _on_orb_manager_combo_at(loc: Vector2) -> void:
	shockwave_rect.play_shockwave_at(loc)
	game_camera.apply_shake()
	if turn_limit < 0:
		game_over_timer.start()

func _on_game_over_countdown_timer_timeout():
	if turn_limit == -1:
		var game_over = end_game.instantiate()
		add_child(game_over)
