extends Node

@export var default_cursor_texture : Texture2D
@export var hover_cursor_texture : Texture2D # Cursor when hovering an interactable, no item selected
@export var item_cursor_hotspot : Vector2 = Vector2(50, 50)

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Connect signals
	InventoryManager.selection_changed.connect(_on_selection_changed)
	# Initialize
	set_process(true)

func _process(_delta: float) -> void:
	_update_cursor()

# ==================================================================================================
#                Cursor methods
# ==================================================================================================
func _update_cursor() -> void:
	var hovered : InteractableComponent = InteractableComponent.current_hovered_interactable
	var selected : ItemData = InventoryManager.selected_item
	if selected and hovered:
		# Show the held item's icon as the cursor when it can be used here
		Input.set_custom_mouse_cursor(selected.icon, Input.CURSOR_ARROW, item_cursor_hotspot)
	elif selected:
		Input.set_custom_mouse_cursor(selected.icon, Input.CURSOR_ARROW, item_cursor_hotspot)
	elif hovered:
		Input.set_custom_mouse_cursor(hover_cursor_texture, Input.CURSOR_ARROW)
	else:
		Input.set_custom_mouse_cursor(default_cursor_texture, Input.CURSOR_ARROW)

func _on_selection_changed(item_data: ItemData) -> void:
	_update_cursor()
