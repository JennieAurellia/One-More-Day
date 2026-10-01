extends Control
class_name UIBlock

static var instance : UIBlock

func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

#func _ready() -> void: unblock_ui()

func block_ui(): show()

func unblock_ui(): hide()
