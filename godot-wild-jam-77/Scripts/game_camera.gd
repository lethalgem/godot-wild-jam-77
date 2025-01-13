class_name GameCamera extends Camera2D

@export var starting_strength: float = 30.0
@export var shake_fade_rate: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
@onready var original_position: Vector2 = offset

func apply_shake():
	print(original_position)
	shake_strength = starting_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade_rate * delta)
		
		offset = original_position + randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
