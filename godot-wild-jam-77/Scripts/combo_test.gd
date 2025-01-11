class_name ComboTest extends Node2D

# TODO: Make this an orb manager within the test scene. The test shouldn't have this logic
@export var spawn_after_time: float = 1.0

var orb_scene = preload("res://Scenes/orb.tscn")
var holding_orb: Orb
var should_drop_orb: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_orb_at_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and holding_orb != null:
		drop_orb()
		await get_tree().create_timer(spawn_after_time).timeout
		spawn_orb_at_mouse()

func _process(delta: float) -> void:
	if holding_orb != null:
		# TODO: Add a smooth interpolation lag so it feels nice
		holding_orb.position = get_global_mouse_position()

func spawn_orb_at_mouse():
	var orb_instance = orb_scene.instantiate()
	add_child(orb_instance)
	holding_orb = orb_instance
	holding_orb.body.freeze = true

func drop_orb():
	# TODO: When smooth following is in, keep track of velocity and add it when dropped
	# This will have the ball move left and right, not just down and the player can shoot diagonally
	holding_orb.body.freeze = false
	holding_orb = null
