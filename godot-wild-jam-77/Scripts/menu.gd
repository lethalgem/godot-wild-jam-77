extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back_pressed() -> void:
	self.visible = false


func _on_settings_pressed():
	toggle_menu()

func toggle_menu():
	self.visible = true
