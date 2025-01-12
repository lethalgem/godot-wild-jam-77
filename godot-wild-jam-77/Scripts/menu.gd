extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_pressed():
	pass # Replace with function body.


func _on_back_pressed() -> void:
	self.visible = false


func _on_settings_pressed():
	toggle_menu()

func toggle_menu():
	self.visible = true


func _unhandled_input(event):
	if self.visible and event.is_action_pressed("left_click"):
		event.consume()
