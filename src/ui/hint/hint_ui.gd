extends Control
class_name HintUI

static var instance : HintUI

@export_subgroup("References")
@export var clue_content : MarginContainer
@export var tutorial_margin : MarginContainer
@export var clue_animation : AnimationPlayer
@export var tutorial_animation : AnimationPlayer

@export_subgroup("Animation Settings")
@export var show_clue_animation_name : String = "show_clue"
@export var show_tutorial_animation_name : String = "show_tutorial"

@export_subgroup("Audio Settings")
@export var hint_sfx_name : String = "hint"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

func _ready() -> void:
	# Assertion check
	assert(clue_content, "clue_content is missing")
	assert(tutorial_margin, "tutorial_margin is missing")
	assert(clue_animation, "clue_animation is missing")
	assert(tutorial_animation, "tutorial_animation is missing")
	# Connect signals
	EventFlag.instance.clue_hinted.connect(show_clue_hint)
	# Initialize
	tutorial_margin.hide()
	clue_content.hide()

# ==================================================================================================
#                Hint methods
# ==================================================================================================
func show_clue_hint() -> void:
	clue_animation.play(show_clue_animation_name)
	AudioManager.play_sfx(hint_sfx_name)

func show_tutorial_hint() -> void:
	tutorial_animation.play(show_tutorial_animation_name)
