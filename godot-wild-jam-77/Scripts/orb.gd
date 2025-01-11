class_name Orb extends Node2D

@export var background_color: Color = Color.WHITE
@export var radius: float = 10.0

@export var body: RigidBody2D
@export var background: OrbBackground
@export var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background.background_color = background_color
	background.radius = radius
	collision_shape.shape.radius = radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
