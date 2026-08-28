extends CharacterBody2D
class_name Elena

enum NPCState{
	COOKING,
	SERVING_FOOD,
	EATING,
	SITTING_SOFA,
	SHOWERING,
	IN_BEDROOM,
	DRESSING_UP,
	PHONE_CALL,
	GOING_OUTSIDE,
}

signal state_changed(state:NPCState)
signal arrived_at_destination

@export_subgroup("References")
@export var nav_agent : NavigationAgent2D
@export var sprite : Sprite2D

@export_subgroup("Movement Settings")
@export var movement_speed : float = 200.0
@export var arrival_distance : float = 4.0

@export_subgroup("Rotation Settings")
## Higher = snappier turning. Set to 0 for instant rotation.
@export var rotation_speed : float = 10.0

@export_subgroup("State Settings")
## Maps game clock minute (e.g. 360 = 06:00) to the state the NPC enters at that time
@export var schedule_dictionary : Dictionary[int, NPCState]
## Where the NPC should walk to for each state (optional — states with no entry just stay put)
@export var state_position_dictionary : Dictionary[NPCState, Marker2D]
## Facing angle (degrees) to snap to once arrived at a state's position.
## States with no entry keep facing their last movement direction.
@export var state_facing_dictionary : Dictionary[NPCState, float]
## Which room each state's destination is in (used to route through doors)
@export var state_room_dictionary : Dictionary[NPCState, EnumUtility.RoomName]

@export_subgroup("Room Settings")
@export var initial_room : EnumUtility.RoomName

var current_state : NPCState

var _target_position : Vector2
var _target_rotation : float = 0.0
var _sorted_schedule_times : Array[int]
var _has_arrived : bool = true
var _current_room : EnumUtility.RoomName
var _travel_id : int = 0

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(!schedule_dictionary.is_empty(), "schedule_dictionary is empty")
	assert(GameTimer.instance, "GameTimer.instance is missing")
	# Connect signals
	if nav_agent: nav_agent.velocity_computed.connect(_on_velocity_computed)
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	_target_position = global_position
	_target_rotation = rotation
	_sorted_schedule_times = schedule_dictionary.keys()
	_sorted_schedule_times.sort()
	_apply_state_for_minute(GameTimer.instance.get_game_time_minute())

func _physics_process(delta: float) -> void:
	_do_movement(delta)
	_check_arrival()
	_do_rotation(delta)

# ==================================================================================================
#                NPC methods
# ==================================================================================================
func _do_movement(delta:float) -> void:
	if nav_agent:
		if nav_agent.is_navigation_finished(): return
		var next_path_position : Vector2 = nav_agent.get_next_path_position()
		var direction : Vector2 = global_position.direction_to(next_path_position)
		nav_agent.set_velocity(direction * movement_speed)
	else:
		if global_position.distance_to(_target_position) > arrival_distance:
			var direction : Vector2 = (_target_position - global_position).normalized()
			velocity = direction * movement_speed
		else:
			velocity = Vector2.ZERO
	move_and_slide()

func _check_arrival() -> void:
	# Check arrived is already triggered yet
	if _has_arrived: return
	# Check has arrived yet
	var reached : bool = false
	if nav_agent: reached = nav_agent.is_navigation_finished()
	else: reached = global_position.distance_to(_target_position) <= arrival_distance
	# Do arrived trigger if arrived
	if reached:
		_has_arrived = true
		global_position = _target_position
		velocity = Vector2.ZERO
		if state_facing_dictionary.has(current_state):
			_target_rotation = deg_to_rad(state_facing_dictionary[current_state])
		arrived_at_destination.emit()

func _do_rotation(delta:float) -> void:
	# Update target rotation only while actually moving
	if velocity.length_squared() > 1.0: _target_rotation = velocity.angle()
	# Always interpolate towards the target rotation, even after stopping
	if rotation_speed <= 0.0: rotation = _target_rotation
	else: rotation = lerp_angle(rotation, _target_rotation, rotation_speed * delta)

func _move_to(new_position:Vector2) -> void:
	_has_arrived = false
	_target_position = new_position
	if nav_agent: nav_agent.target_position = new_position

func _enter_state(state:NPCState) -> void:
	current_state = state
	if state_position_dictionary.has(state):
		var dest_room : EnumUtility.RoomName = state_room_dictionary.get(state, _current_room)
		_travel_id += 1
		_do_travel(state_position_dictionary[state].global_position, dest_room, _travel_id)
	else:
		_has_arrived = true
	state_changed.emit(state)

func _do_travel(
	destination: Vector2, destination_room: EnumUtility.RoomName, travel_id: int
) -> void:
	# Check if next destination is in different room
	if destination_room != _current_room:
		# Find door path to room
		var door_path : Array[Door]
		door_path = DoorManager.instance.find_door_path(_current_room, destination_room)
		if door_path.is_empty():
			push_error("No door path from %s to %s" % [_current_room, destination_room])
		# Loop all doors in path
		for door in door_path:
			if travel_id != _travel_id: return # a newer state change cancelled this route
			var from_push_side : bool = (_current_room == door.push_side_room)
			var near_marker : Marker2D
			near_marker = door.push_side_marker if from_push_side else door.pull_side_marker
			var far_marker : Marker2D
			far_marker = door.pull_side_marker if from_push_side else door.push_side_marker
			# Move to door
			_move_to(near_marker.global_position)
			await arrived_at_destination
			if travel_id != _travel_id: return
			# Wait for door to open
			await door.open_for_transit(_current_room)
			if travel_id != _travel_id: return
			# Go through the door
			_move_to(far_marker.global_position)
			await arrived_at_destination
			if travel_id != _travel_id: return
			# Update room
			_current_room = door.pull_side_room if from_push_side else door.push_side_room
	# Go to destination position inside destined room
	if travel_id != _travel_id: return
	_move_to(destination)

## Finds the most recent schedule entry at or before the given minute and enters that state.
## Used both for live ticks and for catching up on _ready() if the game starts mid-schedule.
func _apply_state_for_minute(minute: int) -> void:
	var applicable_time : int = -1
	for time in _sorted_schedule_times:
		if time <= minute: applicable_time = time
		else: break
	if applicable_time != -1:
		_enter_state(schedule_dictionary[applicable_time])

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_time_tick(game_time_minute:int) -> void:
	if schedule_dictionary.has(game_time_minute):
		_enter_state(schedule_dictionary[game_time_minute])

func _on_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
