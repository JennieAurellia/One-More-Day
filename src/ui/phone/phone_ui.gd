extends Control
class_name PhoneUI

@export var chat_log_display : ChatLogDisplay
@export var close_button : Button

func _ready() -> void:
	# Assertion check
	assert(chat_log_display, "chat_log_display is missing")
	assert(close_button, "close_button is missing")
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):hide())
	EventFlag.instance.peaked_inside_phone.connect(show)
	close_button.pressed.connect(hide)
	# Initialize
	chat_log_display.load_chat_log(ChatLog.log_array)
	hide()
