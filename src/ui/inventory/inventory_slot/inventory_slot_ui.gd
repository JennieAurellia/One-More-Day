extends Control
class_name InventorySlotUI

@export_subgroup("References")
@export var button : TextureButton
@export var content : Control
@export var item_texture_rect : TextureRect

@export_subgroup("Button Tween Settings")
@export var normal_scale : float = 1.0
@export var normal_color : Color = Color(1.0, 1.0, 1.0, 1.0)
@export var hover_scale : float = 1.6
@export var hover_color : Color = Color(2.0, 2.0, 2.0)
@export var selected_scale : float = 1.0
@export var selected_color : Color = Color(0.4, 0.0, 0.0)
@export var tween_transition : Tween.TransitionType = Tween.TRANS_SINE
@export var tween_ease : Tween.EaseType = Tween.EASE_OUT
@export var tween_duration : float = 0.16

var item_data : ItemData = null

var _tween : Tween
var _is_selected = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(button, "button is missing")
	assert(content, "content is missing")
	assert(item_texture_rect, "item_texture_rect is missing")
	# Connect signals
	button.pressed.connect(_on_pressed)
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)

# ==================================================================================================
#                Inventory slot methods
# ==================================================================================================
func set_item_data(new_item_data:ItemData):
	item_data = new_item_data
	item_texture_rect.texture = item_data.icon
	tooltip_text = item_data.display_name

# ==================================================================================================
#                Button methods
# ==================================================================================================
func do_normal(): _animate_button(normal_scale, normal_color)

func do_hover(): _animate_button(hover_scale, hover_color)

func toggle_selected(is_selected:bool):
	_is_selected = is_selected
	if is_selected:
		content.scale = Vector2.ONE * selected_scale
		content.modulate = selected_color
	else:
		content.scale = Vector2.ONE * normal_scale
		content.modulate = normal_color

func _animate_button(target_scale:float, target_color:Color) -> void:
	if _tween and _tween.is_valid(): _tween.kill()
	_tween = create_tween()
	_tween.set_trans(tween_transition).set_ease(tween_ease).set_parallel(true)
	_tween.tween_property(content, "scale", Vector2.ONE * target_scale, tween_duration)
	_tween.tween_property(content, "modulate", target_color, tween_duration)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_pressed(): InventoryManager.select_item(item_data)

func _on_mouse_entered() -> void: if !_is_selected: do_hover()
	
func _on_mouse_exited() -> void: if !_is_selected: do_normal()
