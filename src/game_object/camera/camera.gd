extends Camera2D
class_name Camera

static var instance : Camera

@export_subgroup("Camera Settings")
## Maps out room with corresponding node position
@export var room_position_dictionary : Dictionary[EnumUtility.RoomName, Marker2D]
## Maps out room with corresponding zoom value
@export var room_zoom_dictionary : Dictionary[EnumUtility.RoomName, float]
@export var initial_room : EnumUtility.RoomName
@export var zoom_smoothing_speed : float = 5.0

var current_room : EnumUtility.RoomName

var _target_zoom : float = 1.0

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

func _ready() -> void:
	# Assertion check
	assert(!room_position_dictionary.is_empty(), "room_position_dictionary is empty")
	assert(!room_zoom_dictionary.is_empty(), "room_zoom_dictionary is empty")
	# Initialize
	if room_position_dictionary.has(initial_room) and room_zoom_dictionary.has(initial_room):
		current_room = initial_room
		# Snap instantly to the starting room (no smoothing on first placement)
		position_smoothing_enabled = false
		global_position = room_position_dictionary[initial_room].global_position
		_target_zoom = room_zoom_dictionary[initial_room]
		zoom = Vector2.ONE * _target_zoom
		call_deferred("_enable_smoothing")
	else:
		var error_message : String = "initial_room '"
		error_message += str(initial_room)
		error_message += "' not found in room_position_dictionary or room_zoom_dictionary"
		push_error(error_message)

func _process(delta: float) -> void:
	# Smoothly interpolate zoom towards the target every frame
	if not zoom.is_equal_approx(Vector2.ONE * _target_zoom):
		zoom = zoom.lerp(Vector2.ONE * _target_zoom, zoom_smoothing_speed * delta)

# ==================================================================================================
#                Camera methods
# ==================================================================================================
func change_to_room(room:EnumUtility.RoomName) -> void:
	# Check is valid
	if not room_position_dictionary.has(room):
		push_error("Room '%s' not found in room_dictionary" % room)
		return
	if room == current_room: return
	# Change room
	current_room = room
	_move_to_room(current_room)
	_zoom_to_room(current_room)

func _move_to_room(room:EnumUtility.RoomName) -> void:
	var target_marker : Marker2D = room_position_dictionary[room]
	global_position = target_marker.global_position

func _zoom_to_room(room:EnumUtility.RoomName) -> void:
	_target_zoom = room_zoom_dictionary[room]

func _enable_smoothing() -> void: position_smoothing_enabled = true
