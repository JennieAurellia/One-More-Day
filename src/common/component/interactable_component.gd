extends Node
class_name InteractableComponent

signal interactable_hovered
signal interactable_unhovered
signal interactable_interacted
signal item_used_on(item_data:ItemData)

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
func interact() -> void:
	var held_item_data : ItemData = InventoryManager.selected_item
	if held_item_data:
		item_used_on.emit(held_item_data)
		InventoryManager.select_item(null)
	else: interactable_interacted.emit()

func get_position() -> Vector2: return get_parent().global_position

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered():
	current_hovered_interactable = self
	interactable_hovered.emit()
func _on_mouse_exited():
	current_hovered_interactable = null
	interactable_unhovered.emit()
