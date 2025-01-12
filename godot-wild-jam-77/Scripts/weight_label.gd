class_name AnimatedLabel extends Label

@export var time_to_animate: float = 0.2

var is_animating = false
var final_text: String = ""
var time_animating: float = 0
var number_of_animating_chars = 0
var digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_animating:
		time_animating += delta
		
	if time_animating > time_to_animate:
		is_animating = false
		text = final_text
		time_animating = 0
	elif is_animating:
		var animating_text = ""
		for char in range(number_of_animating_chars):
			animating_text += digits.pick_random()
		text = animating_text

func update_text(new_text: String):
	final_text = new_text
	number_of_animating_chars = new_text.length()
	is_animating = true
