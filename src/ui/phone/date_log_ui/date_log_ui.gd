extends Control
class_name DateLogUI

@export var content_label : Label

func _ready() -> void:
	assert(content_label, "content_label is missing")

func set_content(content:String): content_label.text = content
