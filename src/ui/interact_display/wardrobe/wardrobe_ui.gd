extends Control
class_name WardrobeUI

@export_subgroup("References Box 1")
@export var box_1_button : Button
@export var box_1_interact_hover_ui : Control
@export var box_1_closed : TextureRect
@export var box_1_opened : TextureRect
@export_subgroup("References Box 2")
@export var box_2_button : Button
@export var box_2_interact_hover_ui : Control
@export var box_2_closed : TextureRect
@export var box_2_opened : TextureRect
@export_subgroup("References Cloth 1")
@export var cloth_1_button : Button
@export var cloth_1_interact_hover_ui : Control
@export_subgroup("References Cloth 2")
@export var cloth_2_button : Button
@export var cloth_2_interact_hover_ui : Control
@export_subgroup("References Cloth 3")
@export var cloth_3_button : Button
@export var cloth_3_interact_hover_ui : Control
@export_subgroup("References Closet")
@export var closet_button : Button
@export var closet_interact_hover_ui : Control
@export var closet_opened : TextureRect
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
@export var box_sfx_name : String = "wardrobe_box"
@export var cloth_sfx_name : String = "wardrobe_cloth"
@export var closet_sfx_name : String = "wardrobe_closet"

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(box_1_button, "box_1_button is missing")
	assert(box_1_interact_hover_ui, "box_1_interact_hover_ui is missing")
	assert(box_1_closed, "box_1_closed is missing")
	assert(box_1_opened, "box_1_opened is missing")
	
	assert(box_2_button, "box_2_button is missing")
	assert(box_2_interact_hover_ui, "box_2_interact_hover_ui is missing")
	assert(box_2_closed, "box_2_closed is missing")
	assert(box_2_opened, "box_2_opened is missing")
	
	assert(cloth_1_button, "cloth_1_button is missing")
	assert(cloth_1_interact_hover_ui, "cloth_1_interact_hover_ui is missing")
	
	assert(cloth_2_button, "cloth_2_button is missing")
	assert(cloth_2_interact_hover_ui, "cloth_2_interact_hover_ui is missing")
	
	assert(cloth_3_button, "cloth_3_button is missing")
	assert(cloth_3_interact_hover_ui, "cloth_3_interact_hover_ui is missing")
	
	assert(closet_button, "closet_button is missing")
	assert(closet_interact_hover_ui, "closet_interact_hover_ui is missing")
	assert(closet_opened, "closet_opened is missing")
	
	assert(item_button, "item_button is missing")
	assert(item_interact_hover_ui, "item_interact_hover_ui is missing")
	assert(item_texture_rect, "item_texture_rect is missing")
	
	assert(close_button, "close_button is missing")
	
	assert(key_item_data, "key_item_data is empty")
	assert(found_item_data, "found_item_data is empty")
	
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):
		if visible: EventFlag.instance.wardrobe_closed.emit()
		)
	EventFlag.instance.wardrobe_opened.connect(_on_wardrobe_opened)
	EventFlag.instance.wardrobe_closed.connect(hide)
	
	box_1_button.mouse_entered.connect(_on_box_1_mouse_entered)
	box_1_button.mouse_exited.connect(_on_box_1_mouse_exited)
	box_1_button.pressed.connect(_on_box_1_pressed)
	
	box_2_button.mouse_entered.connect(_on_box_2_mouse_entered)
	box_2_button.mouse_exited.connect(_on_box_2_mouse_exited)
	box_2_button.pressed.connect(_on_box_2_pressed)
	
	cloth_1_button.mouse_entered.connect(_on_cloth_1_mouse_entered)
	cloth_1_button.mouse_exited.connect(_on_cloth_1_mouse_exited)
	cloth_1_button.pressed.connect(_on_cloth_1_pressed)
	
	cloth_2_button.mouse_entered.connect(_on_cloth_2_mouse_entered)
	cloth_2_button.mouse_exited.connect(_on_cloth_2_mouse_exited)
	cloth_2_button.pressed.connect(_on_cloth_2_pressed)
	
	cloth_3_button.mouse_entered.connect(_on_cloth_3_mouse_entered)
	cloth_3_button.mouse_exited.connect(_on_cloth_3_mouse_exited)
	cloth_3_button.pressed.connect(_on_cloth_3_pressed)
	
	closet_button.mouse_entered.connect(_on_closet_mouse_entered)
	closet_button.mouse_exited.connect(_on_closet_mouse_exited)
	closet_button.pressed.connect(_on_closet_pressed)
	
	item_button.mouse_entered.connect(_on_item_mouse_entered)
	item_button.mouse_exited.connect(_on_item_mouse_exited)
	item_button.pressed.connect(_on_item_pressed)
	
	close_button.pressed.connect(func():EventFlag.instance.wardrobe_closed.emit())
	
	# Initialize
	box_1_interact_hover_ui.hide()
	box_1_closed.show()
	box_1_opened.hide()
	
	box_2_interact_hover_ui.hide()
	box_2_closed.show()
	box_2_opened.hide()
	
	cloth_1_interact_hover_ui.hide()
	
	cloth_2_interact_hover_ui.hide()
	
	cloth_3_interact_hover_ui.hide()
	
	closet_interact_hover_ui.hide()
	closet_opened.hide()
	
	item_button.hide()
	item_interact_hover_ui.hide()
	item_texture_rect.hide()
	
	hide()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_wardrobe_opened():
	closet_button.show()
	closet_opened.hide()
	show()

func _on_box_1_mouse_entered(): box_1_interact_hover_ui.show()
func _on_box_2_mouse_entered(): box_2_interact_hover_ui.show()
func _on_cloth_1_mouse_entered(): cloth_1_interact_hover_ui.show()
func _on_cloth_2_mouse_entered(): cloth_2_interact_hover_ui.show()
func _on_cloth_3_mouse_entered(): cloth_3_interact_hover_ui.show()
func _on_closet_mouse_entered(): closet_interact_hover_ui.show()
func _on_item_mouse_entered(): item_interact_hover_ui.show()

func _on_box_1_mouse_exited(): box_1_interact_hover_ui.hide()
func _on_box_2_mouse_exited(): box_2_interact_hover_ui.hide()
func _on_cloth_1_mouse_exited(): cloth_1_interact_hover_ui.hide()
func _on_cloth_2_mouse_exited(): cloth_2_interact_hover_ui.hide()
func _on_cloth_3_mouse_exited(): cloth_3_interact_hover_ui.hide()
func _on_closet_mouse_exited(): closet_interact_hover_ui.hide()
func _on_item_mouse_exited(): item_interact_hover_ui.hide()

func _on_box_1_pressed():
	box_1_button.hide()
	box_1_closed.hide()
	box_1_opened.show()
	AudioManager.play_sfx(box_sfx_name)

func _on_box_2_pressed():
	box_2_button.hide()
	box_2_closed.hide()
	box_2_opened.show()
	AudioManager.play_sfx(box_sfx_name)

func _on_cloth_1_pressed():
	cloth_1_button.hide()
	AudioManager.play_sfx(cloth_sfx_name)

func _on_cloth_2_pressed():
	cloth_2_button.hide()
	AudioManager.play_sfx(cloth_sfx_name)

func _on_cloth_3_pressed():
	cloth_3_button.hide()
	InventoryManager.add_item(key_item_data)
	AudioManager.play_sfx(cloth_sfx_name)

func _on_closet_pressed():
	closet_button.hide()
	closet_opened.show()
	item_button.visible = !InventoryManager.has_item(found_item_data.id)
	item_texture_rect.visible = !InventoryManager.has_item(found_item_data.id)
	AudioManager.play_sfx(closet_sfx_name)

func _on_item_pressed():
	item_button.hide()
	item_texture_rect.hide()
	InventoryManager.add_item(found_item_data)
