extends Control
class_name PauseUI

@export_subgroup("References")
@export var resume_button : Button
@export var quit_button : Button
@export var animation : AnimationPlayer

@export_subgroup("Pause Settings")
@export var quit_scene_path : String

@export_subgroup("Animation Settings")
@export var load_animation_name : String = "load"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(resume_button, "resume_button is missing")
	assert(quit_button, "quit_button is missing")
	assert(animation, "animation is missing")
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
	InventoryManager.select_item(null)
	get_tree().paused = true
	visible = true
	animation.play(load_animation_name)

func _unpause() -> void:
	get_tree().paused = false
	visible = false
	if animation.is_playing(): animation.stop()

func _quit_game() -> void:
	get_tree().paused = false
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	SceneManager.change_scene(quit_scene_path)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_resume_pressed() -> void: _unpause()

func _on_quit_pressed() -> void: _quit_game()
