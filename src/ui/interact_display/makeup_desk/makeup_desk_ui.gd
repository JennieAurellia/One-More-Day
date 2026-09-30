extends Control
class_name MakeupDeskUI

@export_subgroup("References Desk Open")
@export var desk_open_button : Button
@export var desk_open_interact_hover_ui : Control
@export var desk_opened : TextureRect
@export_subgroup("References Item")
@export var item_button : Button
@export var item_interact_hover_ui : Control
@export var item_texture_rect : TextureRect
@export_subgroup("References Others")
@export var close_button : Button

@export_subgroup("Item Settings")
@export var key_item_data : ItemData
@export var found_item_data : ItemData

@export_subgroup("Audio Settings")
@export var open_sfx_name : String = "desk_open"
@export var close_sfx_name : String = "desk_close"

var _is_item_taken : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(desk_open_button, "desk_open_button is missing")
	assert(desk_open_interact_hover_ui, "desk_open_interact_hover_ui is missing")
	assert(desk_opened, "desk_opened is missing")
	
	assert(item_button, "item_button is missing")
	assert(item_interact_hover_ui, "item_interact_hover_ui is missing")
	assert(item_texture_rect, "item_texture_rect is missing")
	
	assert(close_button, "close_button is missing")
	
	assert(key_item_data, "key_item_data is empty")
	assert(found_item_data, "found_item_data is empty")
	
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):
		EventFlag.instance.makeup_desk_released.emit()
		)
	EventFlag.instance.makeup_desk_used.connect(_on_makeup_desk_opened)
	EventFlag.instance.makeup_desk_released.connect(_on_makeup_desk_hidden)
	
	desk_open_button.mouse_entered.connect(_on_desk_open_mouse_entered)
	desk_open_button.mouse_exited.connect(_on_desk_open_mouse_exited)
	desk_open_button.pressed.connect(_on_desk_open_pressed)
	
	item_button.mouse_entered.connect(_on_item_mouse_entered)
	item_button.mouse_exited.connect(_on_item_mouse_exited)
	item_button.pressed.connect(_on_item_pressed)
	
	close_button.pressed.connect(func():EventFlag.instance.makeup_desk_released.emit())
	
	# Initialize
	desk_open_interact_hover_ui.hide()
	desk_opened.hide()
	
	item_button.hide()
	item_interact_hover_ui.hide()
	item_texture_rect.hide()
	
	hide()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_makeup_desk_opened():
	desk_open_button.show()
	desk_opened.hide()
	show()
	
func _on_makeup_desk_hidden():
	if desk_opened.visible: AudioManager.play_sfx(close_sfx_name)
	hide()

func _on_desk_open_mouse_entered():
	if !InventoryManager.selected_item: return
	if InventoryManager.selected_item.id == key_item_data.id: desk_open_interact_hover_ui.show()

func _on_item_mouse_entered(): item_interact_hover_ui.show()

func _on_desk_open_mouse_exited(): desk_open_interact_hover_ui.hide()
func _on_item_mouse_exited(): item_interact_hover_ui.hide()

func _on_desk_open_pressed():
	if !InventoryManager.selected_item: return
	if InventoryManager.selected_item.id == key_item_data.id:
		desk_open_button.hide()
		desk_opened.show()
		item_button.visible = !_is_item_taken
		item_texture_rect.visible = !_is_item_taken
		InventoryManager.select_item(null)
		AudioManager.play_sfx(open_sfx_name)

func _on_item_pressed():
	_is_item_taken = true
	item_button.hide()
	item_texture_rect.hide()
	InventoryManager.add_item(found_item_data)
