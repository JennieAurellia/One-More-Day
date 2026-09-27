extends Control
class_name DiaryUI

@export var prev_page_button : Button
@export var prev_page_icon : TextureRect
@export var next_page_button : Button
@export var next_page_icon : TextureRect
@export var close_button : Button
@export var page_array : Array[Control]

var current_page_index : int = 0

func _ready() -> void:
	# Assertion check
	assert(prev_page_button, "prev_page_button is missing")
	assert(prev_page_icon, "prev_page_icon is missing")
	assert(next_page_button, "next_page_button is missing")
	assert(next_page_icon, "next_page_icon is missing")
	assert(close_button, "close_button is missing")
	assert(!page_array.is_empty(), "page_array is empty")
	# Connect signals
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):hide())
	EventFlag.instance.read_diary.connect(show)
	next_page_button.pressed.connect(next_page)
	prev_page_button.pressed.connect(prev_page)
	close_button.pressed.connect(hide)
	# Initialize
	initialize_page()
	hide()

func initialize_page():
	current_page_index = 0
	for index:int in page_array.size():
		page_array[index].visible = (index == current_page_index)
	_update_nav_buttons()

func next_page():
	if current_page_index >= page_array.size() - 1: return
	page_array[current_page_index].hide()
	current_page_index += 1
	page_array[current_page_index].show()
	_update_nav_buttons()

func prev_page():
	if current_page_index <= 0: return
	page_array[current_page_index].hide()
	current_page_index -= 1
	page_array[current_page_index].show()
	_update_nav_buttons()

func _update_nav_buttons() -> void:
	prev_page_button.visible = current_page_index > 0
	prev_page_icon.visible = current_page_index > 0
	next_page_button.visible = current_page_index < page_array.size() - 1
	next_page_icon.visible = current_page_index < page_array.size() - 1
