extends Control

var is_menu_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_pressed():
	pass # Replace with function body.


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_settings_pressed():
	toggle_menu()

func toggle_menu():
	var menu_root = get_node('.')
	
	if menu_root == null:
		return
	is_menu_open = !is_menu_open
	menu_root.visible = is_menu_open
		
func _unhandled_input(event):
	if is_menu_open:
		event.consume()
