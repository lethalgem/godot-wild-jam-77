class_name Background extends ColorRect

var line_2_colors = [Color.hex(0xc3c3e5ff), Color.hex(0xac2effff), Color.hex(0x443266ff)]

var beat_counter: int = 0:
	get:
		return beat_counter
	set(new_val):
		if new_val > 2 or new_val < 0:
			beat_counter = 0
		else:
			beat_counter = new_val

func _on_bpm_timer_timeout() -> void:
	print("timer fired")
	var new_color
	if beat_counter == 0:
		new_color = line_2_colors[1]
	elif beat_counter == 1:
		new_color = line_2_colors[2]
	elif beat_counter == 2:
		new_color = line_2_colors[0]
	
	self.material.set_shader_parameter("color_two", new_color)

	beat_counter += 1
