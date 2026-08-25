extends Node2D
class_name RoomFog

static var instance : RoomFog

@export_subgroup("Room Settings")
## Maps out room with corresponding color rect
@export var room_rect_dictionary : Dictionary[EnumUtility.RoomName, ColorRect]
@export var initial_room : EnumUtility.RoomName

@export_subgroup("Fade Settings")
@export var fade_duration : float = 0.6
@export var fade_trans : Tween.TransitionType = Tween.TRANS_SINE
@export var fade_ease : Tween.EaseType = Tween.EASE_IN_OUT

var current_room : EnumUtility.RoomName
var _fade_tween : Tween

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self
func _exit_tree() -> void: instance = null

func _ready() -> void:
	# Assertion check
	assert(!room_rect_dictionary.is_empty(), "room_rect_dictionary is empty")
	# Initialize
	for room_rect:ColorRect in room_rect_dictionary.values():
		room_rect.show()
		room_rect.modulate.a = 1.0

	if room_rect_dictionary.has(initial_room):
		current_room = initial_room
		room_rect_dictionary[initial_room].hide()
		room_rect_dictionary[initial_room].modulate.a = 0.0
	else:
		push_error("initial_room '%s' not found in room_rect_dictionary" % initial_room)

# ==================================================================================================
#                Fog methods
# ==================================================================================================
func change_to_room(room:EnumUtility.RoomName) -> void:
	# Check is valid
	if not room_rect_dictionary.has(room):
		push_error("Room '%s' not found in room_rect_dictionary" % room)
		return
	if room == current_room: return
	# Set variables
	var old_room_rect : ColorRect = room_rect_dictionary[current_room]
	var new_room_rect : ColorRect = room_rect_dictionary[room]
	current_room = room
	# Do fading tween
	if _fade_tween and _fade_tween.is_valid(): _fade_tween.kill()
	old_room_rect.show()
	new_room_rect.show()
	_fade_tween = create_tween()
	_fade_tween.set_parallel(true)
	_fade_tween.set_trans(fade_trans)
	_fade_tween.set_ease(fade_ease)
	_fade_tween.tween_property(old_room_rect, "modulate:a", 1.0, fade_duration)
	_fade_tween.tween_property(new_room_rect, "modulate:a", 0.0, fade_duration)
	_fade_tween.chain().tween_callback(new_room_rect.hide)
