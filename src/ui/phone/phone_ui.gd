extends Control
class_name PhoneUI

@export var chat_log_display : ChatLogDisplay

func _ready() -> void:
	# Assertion check
	assert(chat_log_display, "chat_log_display is missing")
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):hide())
	EventFlag.instance.peaked_inside_phone.connect(show)
	# Initialize
	chat_log_display.load_chat_log(ChatLog.log_array)
	hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if visible: hide()
