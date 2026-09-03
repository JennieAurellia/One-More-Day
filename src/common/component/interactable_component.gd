extends Node
class_name InteractableComponent

signal hovered
signal unhovered
signal interacted
signal item_used_on(item_data:ItemData)
signal interacted_by_npc(npc:Node)

@export_subgroup("References")
@export var interact_control : Control

static var current_hovered_interactable : InteractableComponent

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Connect signals
	if interact_control: interact_control.mouse_entered.connect(_on_mouse_entered)
	if interact_control: interact_control.mouse_exited.connect(_on_mouse_exited)

# ==================================================================================================
#                Interactable methods
# ==================================================================================================
func interact() -> void:
	var held_item_data : ItemData = InventoryManager.selected_item
	if held_item_data:
		item_used_on.emit(held_item_data)
		InventoryManager.select_item(null)
	else: interacted.emit()

## Called by NPCs instead of interact() — bypasses inventory/item logic entirely.
## Base behavior just fires the normal interact signal; override in subclasses
## (e.g. Seat) for NPC-specific behavior like sitting.
func npc_interact(npc:Node) -> void: interacted_by_npc.emit(npc)

func get_position() -> Vector2: return get_parent().global_position

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_mouse_entered():
	current_hovered_interactable = self
	hovered.emit()
func _on_mouse_exited():
	current_hovered_interactable = null
	unhovered.emit()
