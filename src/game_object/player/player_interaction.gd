extends Node
class_name PlayerInteraction

@export_subgroup("References")
@export var player : Player
@export var interactable_component : InteractableComponent
@export var interact_hover_ui : Control

@export_subgroup("Interaction Settings")
@export var gift_item_data : ItemData
@export var doll_item_data : ItemData
@export var phone_item_data : ItemData
@export var diary_item_data : ItemData

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(player, "player is missing")
	assert(interactable_component, "interactable_component is missing")
	assert(interact_hover_ui, "interact_hover_ui is missing")
	assert(gift_item_data, "gift_item_data is empty")
	assert(doll_item_data, "doll_item_data is empty")
	assert(phone_item_data, "phone_item_data is empty")
	assert(diary_item_data, "diary_item_data is empty")
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.item_used_on.connect(_on_interactable_item_used_on)
	# Initialize
	interact_hover_ui.hide()

func _process(delta: float) -> void:
	interact_hover_ui.rotation = -player.rotation

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	if !InventoryManager.selected_item: return
	if InventoryManager.selected_item.id == gift_item_data.id: interact_hover_ui.show()
	elif InventoryManager.selected_item.id == doll_item_data.id: interact_hover_ui.show()
	elif InventoryManager.selected_item.id == phone_item_data.id: interact_hover_ui.show()
	elif InventoryManager.selected_item.id == diary_item_data.id: interact_hover_ui.show()

func _on_interactable_unhovered(): interact_hover_ui.hide()

func _on_interactable_interacted(): pass

func _on_interactable_item_used_on(item_data:ItemData):
	if item_data.id == gift_item_data.id:
		player.do_dialogue("present_inspect")
		# Flag present
		if !EventFlag.instance.has_peek_present:
			EventFlag.instance.has_peek_present = true
	elif item_data.id == doll_item_data.id:
		player.do_dialogue("doll_inspect")
		# Flag doll
		if !EventFlag.instance.has_peek_doll:
			EventFlag.instance.has_peek_doll = true
	elif item_data.id == phone_item_data.id:
		# Flag phone
		if !EventFlag.instance.has_peek_inside_phone:
			EventFlag.instance.has_peek_inside_phone = true
	elif item_data.id == diary_item_data.id:
		# Flag diary
		if !EventFlag.instance.has_read_diary:
			EventFlag.instance.has_read_diary = true
