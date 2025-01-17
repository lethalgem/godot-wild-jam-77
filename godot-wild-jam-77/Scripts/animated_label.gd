class_name AnimatedLabel extends Label

@export var time_to_animate: float = 0.2
@export var sfx_player: AudioStreamPlayer

var static_text = ""
var is_animating = false
var final_text: String = ""
var time_animating: float = 0
var number_of_animating_chars = 0
var digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
var repeat_sound_delay: float = 0.06 ##sec
var sound_last_played_at: float = 0.0 ##sec

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_animating:
		time_animating += delta
	else:
		sound_last_played_at = 0.0
		
	if time_animating > time_to_animate:
		is_animating = false
		text = static_text + final_text
		time_animating = 0
	elif is_animating:
		var animating_text = static_text
		for i in range(number_of_animating_chars):
			animating_text += digits.pick_random()
		text = animating_text
		
		if time_animating - sound_last_played_at > repeat_sound_delay:
			if sfx_player != null:
				sfx_player.play(0.20)
				sound_last_played_at = time_animating
		

func set_static_text(new_text: String):
	static_text = new_text

func update_text(new_text: String):
	final_text = new_text
	number_of_animating_chars = new_text.length()
	is_animating = true
