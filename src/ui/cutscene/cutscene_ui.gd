extends Control
class_name CutsceneUI

signal cutscene_started(cutscene_name:String)
signal cutscene_finished(cutscene_name:String)
signal cutscene_skipped(cutscene_name:String)

static var instance : CutsceneUI

@export_subgroup("References")
@export var animation : AnimationPlayer

@export_subgroup("Cutscene Settings")
@export var skip_action: String = "ui_cancel"
@export var allow_skip: bool = true

var _is_playing : bool = false
var _current_cutscene_name : String = ""

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

func _ready() -> void:
	# Assertion check
	assert(animation, "animation is missing")
	# Connect signals
	animation.animation_finished.connect(_on_animation_finished)
	# Initialize
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

#func _unhandled_input(event: InputEvent) -> void:
	#if _is_playing and allow_skip and event.is_action_pressed(skip_action):
		#skip_cutscene()
		#get_viewport().set_input_as_handled()

# ==================================================================================================
#                Cutscene methods
# ==================================================================================================
func is_playing() -> bool:
	return _is_playing

func play_cutscene(cutscene_name:String) -> void:
	if _is_playing: return
	assert(
		animation.has_animation(cutscene_name), "Cutscene: %s, does not have animation" % cutscene_name
	)
	_current_cutscene_name = cutscene_name
	_is_playing = true
	get_tree().paused = true
	cutscene_started.emit(cutscene_name)
	animation.play(cutscene_name)
	show()

func end_cutscene() -> void:
	if !_is_playing: return
	_is_playing = false
	get_tree().paused = false
	cutscene_finished.emit(_current_cutscene_name)
	_current_cutscene_name = ""
	hide()

func skip_cutscene() -> void:
	if !_is_playing or !allow_skip: return
	end_cutscene()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_animation_finished(_anim_name: StringName) -> void:
	end_cutscene()
