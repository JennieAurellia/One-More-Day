extends ScrollContainer
class_name ChatLogDisplay

enum ChatType{
	MESSAGE,
	DATE,
	TIME,
}

@export_subgroup("References")
@export var log_parent : Control

@export_subgroup("Display Settings")
@export var message_log_ui_scene : PackedScene
@export var date_log_ui_scene : PackedScene
@export var time_log_ui_scene : PackedScene

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(log_parent, "log_parent is missing")
	assert(message_log_ui_scene, "message_log_scene is empty")
	assert(date_log_ui_scene, "message_log_scene is empty")
	assert(time_log_ui_scene, "message_log_scene is empty")

# ==================================================================================================
#                Display methods
# ==================================================================================================
func load_chat_log(log_array:Array[Dictionary]) -> void:
	clear_log()
	for log_content:Dictionary in log_array: add_log(log_content)

func add_log(log_content:Dictionary) -> void:
	assert(log_content.has("type"), "This log does not have type")
	assert(log_content.has("content"), "This log does not have content")
	match log_content["type"]:
		ChatType.MESSAGE:
			assert(log_content.has("name"), "This log does not have name")
			var is_self : bool = log_content["name"] == "self"
			var log_instance : MessageLogUI = message_log_ui_scene.instantiate()
			log_parent.add_child(log_instance)
			log_instance.set_content(log_content["content"], is_self)
		ChatType.DATE:
			var log_instance : DateLogUI = date_log_ui_scene.instantiate()
			log_parent.add_child(log_instance)
			log_instance.set_content(log_content["content"])
		ChatType.TIME:
			var log_instance : TimeLogUI = time_log_ui_scene.instantiate()
			log_parent.add_child(log_instance)
			log_instance.set_content(log_content["content"])

func clear_log() -> void:
	for log_node:Control in log_parent.get_children():
		log_node.queue_free()
