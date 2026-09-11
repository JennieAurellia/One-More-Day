extends Node
class_name MainMenuController

@export_subgroup("References")
@export var play_button : Button
@export var settings_button : Button
@export var quit_button : Button
@export var skip_button : Button
@export var back_button : Button
@export var animation : AnimationPlayer

@export_subgroup("Main Menu Settings")
@export var play_scene_path : String

@export_subgroup("Animation Settings")
@export var load_animation_name : String = "load"
@export var show_ui_animation_name : String = "show_ui"
@export var show_settings_animation_name : String = "show_settings"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(play_button, "play_button is missing")
	assert(settings_button, "settings_button is missing")
	assert(quit_button, "play_button is missing")
	assert(skip_button, "skip_button is missing")
	assert(back_button, "back_button is missing")
	assert(animation, "animation is missing")
	# Connect signals
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	skip_button.pressed.connect(_on_skip_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	animation.animation_finished.connect(_on_animation_finished)
	# Initialize
	AudioManager.play_music("main_menu")

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_play_button_pressed() -> void:
	GameManager.initialize_game()
	EventFlag.reset_event()
	AudioManager.stop_music(0.5)
	SceneManager.change_scene(play_scene_path)

func _on_quit_button_pressed() -> void:
	AudioManager.stop_music(0.5)
	await TransitionManager.fade_out_to_black()
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	animation.play(show_settings_animation_name)

func _on_skip_button_pressed() -> void:
	skip_button.hide()
	animation.play(show_ui_animation_name)

func _on_back_button_pressed() -> void:
	animation.play_backwards(show_settings_animation_name)

func _on_animation_finished(anim_name:StringName):
	if anim_name == load_animation_name: animation.play(show_ui_animation_name)
