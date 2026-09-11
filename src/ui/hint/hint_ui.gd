extends Control
class_name HintUI

static var instance : HintUI

@export_subgroup("References")
@export var tutorial_hint_margin : MarginContainer
@export var clue_hint_margin : MarginContainer

@export_subgroup("Tutorial Hint Settings")
@export var tutorial_normal_margin : float = 0.0
@export var tutorial_show_margin : float = 10.0
@export var tutorial_show_duration : float = 0.5

@export_subgroup("Clue Hint Settings")
@export var clue_normal_margin : float = 0.0
@export var clue_show_margin : float = 8.0
@export var clue_show_duration : float = 0.5

@export_subgroup("Tween Settings")
@export var tween_duration : float = 0.5

@export_subgroup("Audio Settings")
@export var hint_sfx_name : String = "hint"

var _hint_tween : Tween

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

func _ready() -> void:
	# Assertion check
	assert(tutorial_hint_margin, "tutorial_hint_margin is missing")
	assert(clue_hint_margin, "clue_hint_margin is missing")
	# Connect signals
	EventFlag.instance.peeked_present.connect(show_clue_hint)
	EventFlag.instance.peeked_doll.connect(show_clue_hint)
	EventFlag.instance.peeked_inside_phone.connect(show_clue_hint)
	EventFlag.instance.read_diary.connect(show_clue_hint)
	# Initialize
	hide()

# ==================================================================================================
#                Hint methods
# ==================================================================================================
func show_tutorial_hint() -> void:
	_tween_hint(
		tutorial_hint_margin, tutorial_normal_margin, tutorial_show_margin, tutorial_show_duration
	)

func show_clue_hint() -> void:
	_tween_hint(clue_hint_margin, clue_normal_margin, clue_show_margin, clue_show_duration)

func _tween_hint(
	hint_margin:MarginContainer, normal_margin:float, show_margin:float, show_duration:float
):
	# Kill any tween already running so repeated calls don't stack.
	if _hint_tween and _hint_tween.is_valid(): _hint_tween.kill()
	# Show
	show()
	# Play audio
	AudioManager.play_sfx(hint_sfx_name)
	# Create tween
	_hint_tween = create_tween()
	_hint_tween.set_trans(Tween.TRANS_SINE)
	# Animate out (normal -> show)
	_hint_tween.set_ease(Tween.EASE_OUT)
	_hint_tween.tween_property(
		hint_margin,
		"theme_override_constants/margin_right",
		show_margin,
		tween_duration
	)
	# Hold
	_hint_tween.tween_interval(show_duration)
	# Animate back (show -> normal)
	_hint_tween.set_ease(Tween.EASE_IN)
	_hint_tween.tween_property(
		hint_margin,
		"theme_override_constants/margin_right",
		normal_margin,
		tween_duration
	)
	# Hide
	_hint_tween.tween_callback(hide)
