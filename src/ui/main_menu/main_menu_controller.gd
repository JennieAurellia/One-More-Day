extends Node
class_name MainMenuController

@export_subgroup("References")
@export var play_button : Button

@export_subgroup("Main Menu Settings")
@export var play_scene_path : String

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(play_button, "play_button is missing")
	# Connect signals
	play_button.pressed.connect(_on_play_pressed)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_play_pressed() -> void: get_tree().change_scene_to_file(play_scene_path)
