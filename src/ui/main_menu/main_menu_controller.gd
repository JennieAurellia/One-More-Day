extends Node
class_name MainMenuController

@export_subgroup("References")
@export var play_button : Button
@export var quit_button : Button

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
	quit_button.pressed.connect(_on_quit_pressed)
	# Initialize
	TransitionManager.fade_in_from_black()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_play_pressed() -> void:
	SceneManager.change_scene(play_scene_path)

func _on_quit_pressed() -> void:
	await TransitionManager.fade_out_to_black()
	get_tree().quit()
