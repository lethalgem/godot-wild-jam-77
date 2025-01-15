class_name OrbHover extends Node2D 

@export var hover_label: Label
@export var type_label : Label

# Initialize the hover display
func _ready() -> void:
	# Start with the label hidden and empty
	hover_label.text = ""
	type_label.text = ""
	visible = false

# Function that gets called when we want to show text
func show_hover(orb:String, combo: String) -> void:
	type_label.text = orb
	hover_label.text = combo
	visible = true

# Function to hide the hover display
func hide_hover() -> void:
	visible = false
