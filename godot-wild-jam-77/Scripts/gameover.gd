class_name EngGameScreen extends Control

func _on_restart_pressed():
	print("restart pressed")
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_restart_button_down():
	print("restart pressed")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
