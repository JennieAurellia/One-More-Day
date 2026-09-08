extends Control
class_name PauseUI

@export_subgroup("References")
@export var resume_button : Button
@export var quit_button : Button

@export_subgroup("Pause Settings")
@export var quit_scene_path : String

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(resume_button, "resume_button is missing")
	assert(quit_button, "quit_button is missing")
	# Connect signals
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	# Initialize
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()

# ==================================================================================================
#                Pause methods
# ==================================================================================================
func toggle_pause() -> void:
	if get_tree().paused: _unpause()
	else: _pause()

func _pause() -> void:
	visible = true
	get_tree().paused = true

func _unpause() -> void:
	visible = false
	get_tree().paused = false

func _quit_game() -> void:
	get_tree().paused = false
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	get_tree().change_scene_to_file(quit_scene_path)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_resume_pressed() -> void: _unpause()

func _on_quit_pressed() -> void: _quit_game()
