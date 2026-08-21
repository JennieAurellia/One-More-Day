extends Node
class_name InteractableComponent

signal interactable_hovered
signal interactable_unhovered
signal interactable_interacted

@export_subgroup("References")
@export var interact_control : Control

static var current_hovered_interactable : InteractableComponent

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interact_control, "interact_control is missing")
	# Connect signals
	interact_control.mouse_entered.connect(_on_mouse_entered)
	interact_control.mouse_exited.connect(_on_mouse_exited)

# ==================================================================================================
#                Interactable methods
# ==================================================================================================
func interact(): interactable_interacted.emit()

func get_position()->Vector2: return get_parent().global_position

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered():
	current_hovered_interactable = self
	interactable_hovered.emit()

func _on_mouse_exited():
	current_hovered_interactable = null
	interactable_unhovered.emit()
