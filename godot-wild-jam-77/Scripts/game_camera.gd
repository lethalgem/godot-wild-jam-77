class_name GameCamera extends Camera2D

@export var shake_range: float = 30.0
@export var shake_fade_rate: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
@onready var original_position: Vector2 = offset

func apply_shake():
	shake_strength = shake_range
	
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1.1, 1.1), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.1)
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade_rate * delta)
		
		offset = original_position + randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
