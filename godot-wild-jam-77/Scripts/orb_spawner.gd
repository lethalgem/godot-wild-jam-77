class_name OrbSpawner extends Node2D

# TODO: Make this an orb manager within the test scene. The test shouldn't have this logic
@export var spawn_delay: float = 1.0
@export var orb_manager: OrbManager

var orb_scene = preload("res://Scenes/orb.tscn")
var holding_orb: Orb
var should_drop_orb: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_orb_at_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and holding_orb != null:
		drop_orb()
		await get_tree().create_timer(spawn_delay).timeout
		spawn_orb_at_mouse()

func _process(delta: float) -> void:
	if holding_orb != null:
		# TODO: Add a smooth interpolation lag so it feels nice
		holding_orb.position = get_global_mouse_position()

func spawn_orb_at_mouse():
	var orb_instance: Orb = orb_scene.instantiate()
	var orb_type: OrbType = orb_manager.get_next_orb_type()
	if orb_type == null:
		return
	
	orb_instance.radius = orb_type.properties.radius
	orb_instance.weight = orb_type.properties.weight
	orb_instance.color = orb_type.properties.color
	
	add_child(orb_instance)
	holding_orb = orb_instance
	holding_orb.body.freeze = true

func drop_orb():
	# TODO: When smooth following is in, keep track of velocity and add it when dropped
	# This will have the ball move left and right, not just down and the player can shoot diagonally
	holding_orb.body.freeze = false
	holding_orb = null
