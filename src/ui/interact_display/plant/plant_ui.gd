extends Control
class_name PlantUI

@export var close_button : Button

func _ready() -> void:
	# Assertion check
	assert(close_button, "close_button is missing")
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):hide())
	EventFlag.instance.plant_inspected.connect(show)
	close_button.pressed.connect(hide)
	# Initialize
	hide()
