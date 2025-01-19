class_name SettingsMenu extends Control

func _on_restart_pressed():
	$GridContainer/HBoxContainer/AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_back_pressed() -> void:
	self.visible = false
	$GridContainer/HBoxContainer/AudioStreamPlayer.play()
func _on_settings_pressed():
	toggle_menu()
	$GridContainer/HBoxContainer/AudioStreamPlayer.play()
func toggle_menu():
	self.visible = true
