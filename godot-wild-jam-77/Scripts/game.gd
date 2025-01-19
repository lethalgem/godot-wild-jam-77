class_name Game extends Node

@export_group("Game Settings")
@export var initial_goal_weight: float = 10 ## weight BEFORE global weight multiplier applied
@export var goal_exp_factor: float = 1.1 ## Exponent for how rapidly the score required grows
@export var initial_turn_limit: int = 10
@export var turn_limit_increase: int = 5

@export_group("Obj references")
@export var orb_manager: OrbManager
@export var scale: Scale
@export var turn_limit_label: Label
@export var weight_threshold_label: AnimatedLabel
@export var weight_label: AnimatedLabel
@export var game_camera: GameCamera
@export var fps_label: Label
@export var game_over_timer: Timer
@export var game_over_screen: Control
@export var next_orb_vbox_container: VBoxContainer
@export var next_orb_label: Label
@export var shockwave_audio_player: AudioStreamPlayer
@export var drop_audio_player: AudioStreamPlayer
@export var orb_hover : OrbHover

var shockwave_scene: PackedScene = preload("res://scenes/shockwave.tscn")
var next_orb: Orb

var turn_limit: int:
	get:
		return turn_limit
	set(new_val):
		turn_limit_label.text = "Remaining: " + str(new_val if (new_val > 0) else 0)
		orb_manager.spawn_limit = new_val
		turn_limit = new_val
		
		# Handle next orb preview
		if next_orb != null:
			next_orb.queue_free()
		
		if new_val > 0:
			next_orb = orb_manager.show_next_orb()
			next_orb.radius /= 2
			var next_orb_padding_px = 5
			next_orb.body.global_position = \
			 Vector2(next_orb_label.global_position.x + next_orb_label.size.x + next_orb.radius + next_orb_padding_px,\
			 next_orb_label.global_position.y + next_orb_label.size.y / 2)

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
	weight_threshold_label.set_static_text("Next round at: ")

func _physics_process(_delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_scale_goal_weight_achieved() -> void:
	# force another orb into the player's hand if they ran out of orbs
	var should_give_new_orb = false
	if turn_limit < 0:
		should_give_new_orb = true
	
	if weight_threshold >10000000:
			goal_exp_factor = 0.5
	scale.goal_weight = scale.goal_weight + scale.goal_weight ** goal_exp_factor
	weight_threshold = scale.goal_weight
	if weight_threshold > 1500000:
		turn_limit_increase = 12
		
	turn_limit += turn_limit_increase

	if should_give_new_orb:
		orb_manager.orb_spawner.spawn_next_orb_in_queue()
	

func _on_orb_manager_orb_dropped() -> void:
	if turn_limit == 0:
		game_over_timer.start()
	turn_limit -= 1
	drop_audio_player.play()
	

func _on_scale_updated_weight(weight: float) -> void:
	current_weight = weight

func _on_orb_manager_combo_at(loc: Vector2) -> void:
	var shockwave_instance: Shockwave = shockwave_scene.instantiate()
	add_child(shockwave_instance)
	shockwave_instance.play_shockwave_at(loc)
	game_camera.apply_shake()
	shockwave_audio_player.play(0.5)
	if turn_limit < 0:
		game_over_timer.start()

func _on_game_over_countdown_timer_timeout():
	if turn_limit == -1:
		game_over_screen.visible = true


func _on_orb_manager_orb_is_hovered(orb_type: String, combos: String) -> void:
	orb_hover.show_hover(orb_type, combos)


func _on_orb_manager_orb_is_not_hovered() -> void:
	orb_hover.hide_hover()
