extends Control
class_name TrashUI

@export_subgroup("References Rummage")
@export var rummage_button : Button
@export var rummage_interact_hover_ui : Control
@export var full_texture_rect : TextureRect
@export var half_empty_texture_rect : TextureRect
@export var empty_texture_rect : TextureRect
@export_subgroup("References Others")
@export var close_button : Button

@export_subgroup("Audio Settings")
@export var rummage_sound_name : String = "rummage"

var _trash_fill : int = 2

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(close_button, "close_button is missing")
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):
		_on_trash_can_hidden()
		)
	
	rummage_button.mouse_entered.connect(_on_rummage_mouse_entered)
	rummage_button.mouse_exited.connect(_on_rummage_mouse_exited)
	rummage_button.pressed.connect(_on_rummage_pressed)
	
	EventFlag.instance.trash_can_inspected.connect(show)
	close_button.pressed.connect(_on_trash_can_hidden)
	# Initialize
	rummage_button.show()
	rummage_interact_hover_ui.hide()
	_update_trash_fill()
	hide()

# ==================================================================================================
#                Trash can methods
# ==================================================================================================
func _update_trash_fill():
	full_texture_rect.visible = _trash_fill == 2
	half_empty_texture_rect.visible = _trash_fill == 1
	empty_texture_rect.visible = _trash_fill <= 0

# ==================================================================================================
#                Signal listener methods
# ================================================================================================
func _on_trash_can_hidden():
	AudioManager.stop_sound(rummage_sound_name)
	hide()

func _on_rummage_mouse_entered(): rummage_interact_hover_ui.show()

func _on_rummage_mouse_exited(): rummage_interact_hover_ui.hide()

func _on_rummage_pressed():
	rummage_interact_hover_ui.hide()
	_trash_fill -= 1
	if _trash_fill <= 0: rummage_button.hide()
	_update_trash_fill()
	AudioManager.play_sound(rummage_sound_name, Vector2.ZERO, true)
