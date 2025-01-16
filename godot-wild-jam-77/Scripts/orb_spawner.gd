class_name OrbSpawner extends Node2D

signal orb_dropped

@export var spawn_delay: float = 1.0
@export var orb_manager: OrbManager

const orb_scene = preload("res://scenes/orb.tscn")
var holding_orb: Orb
var should_drop_orb: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_next_orb_in_queue()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and holding_orb != null:
		drop_orb()
		await get_tree().create_timer(spawn_delay).timeout
		spawn_next_orb_in_queue()

func _process(delta: float) -> void:
	if holding_orb != null:
		# lag behind the mouse a bit
		var speed = 0.005 # Unintuitively, the lower the value, the faster it catches the mouse
		var weight = 1.0 - (speed ** delta)
		holding_orb.body.position = Vector2(lerpf(holding_orb.body.position.x, get_desired_position_from_mouse().x, weight), \
		 lerpf(holding_orb.body.position.y, get_desired_position_from_mouse().y, weight))

func spawn_next_orb_in_queue():
	var orb_type: OrbType = orb_manager.get_next_orb_type()
	if orb_type == null:
		return
	
	holding_orb = spawn_orb_at(get_desired_position_from_mouse(), orb_type)
	holding_orb.body.freeze = true
	orb_manager.add_spawned(holding_orb)

func spawn_orb_from_combo_at(location: Vector2, type: OrbType) -> Orb:
	var spawned_orb = spawn_orb_at(location, type)
	spawned_orb.can_combo = true
	spawned_orb.should_impulse = true
	return spawned_orb

func spawn_orb_at(location: Vector2, type: OrbType) -> Orb:
	var orb_instance: Orb = orb_scene.instantiate()
	orb_instance.radius = type.properties.radius
	orb_instance.weight = type.properties.weight
	orb_instance.color = type.properties.color
	orb_instance.allowed_combos = type.properties.allowed_combos
	orb_instance.combo_results = type.properties.combo_results
	orb_instance.type = type.properties.type
	orb_instance.label_text = type.properties.label_text
	orb_instance.body.global_position = location
	call_deferred("add_child", orb_instance)
	return orb_instance

func drop_orb():
	# TODO: When smooth following is in, keep track of velocity and add it when dropped
	# This will have the ball move left and right, not just down and the player can shoot diagonally
	holding_orb.body.freeze = false
	holding_orb.can_combo = true
	holding_orb = null
	orb_dropped.emit()

func get_desired_position_from_mouse() -> Vector2:
	var mouse_position = get_global_mouse_position()
	return Vector2(mouse_position.x, clamp(mouse_position.y, 0, 300))
