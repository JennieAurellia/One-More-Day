extends Control
class_name MessageLogUI

@export var self_parent : Control
@export var self_label : Label
@export var other_parent : Control
@export var other_label : Label
@export var max_width : float = 300.0

func _ready() -> void:
	assert(self_parent, "self_parent is missing")
	assert(self_label, "self_label is missing")
	assert(other_parent, "other_parent is missing")
	assert(other_label, "other_label is missing")

func set_content(content:String, is_self:bool):
	var label : Label
	if is_self:
		self_parent.show()
		other_parent.hide()
		label = self_label
	else:
		self_parent.hide()
		other_parent.show()
		label = other_label
	label.text = content
	await get_tree().process_frame
	if label.size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.custom_minimum_size.x = max_width
		await get_tree().process_frame
		size.x = label.custom_minimum_size.x
	else:
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		label.custom_minimum_size.x = 0 
