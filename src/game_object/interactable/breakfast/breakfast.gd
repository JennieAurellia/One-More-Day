extends Node2D
class_name Breakfast

@export_subgroup("References")
@export var interact_button : Button
@export var interact_hover_ui : Control

@export_subgroup("Audio Settings")
@export var eat_sfx_name : String = "eat"

var _is_eatable : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interact_button, "interact_button is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	# Connect signals
	interact_button.mouse_entered.connect(_on_mouse_entered)
	interact_button.mouse_exited.connect(_on_mouse_exited)
	interact_button.pressed.connect(_on_pressed)
	# Initialize
	interact_hover_ui.hide()

# ==================================================================================================
#                Food methods
# ==================================================================================================
func eat():
	AudioManager.play_sfx(eat_sfx_name)
	queue_free()

func toggle_eatable(is_now_eatable:bool): _is_eatable = is_now_eatable

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered():
	if InventoryManager.selected_item: return
	if EventFlag.instance.is_breakfast_eatable and _is_eatable:
		interact_hover_ui.show()

func _on_mouse_exited():
	interact_hover_ui.hide()

func _on_pressed():
	if EventFlag.instance.is_breakfast_eatable and _is_eatable:
		EventFlag.instance.has_ate_breakfast = true
		eat()
