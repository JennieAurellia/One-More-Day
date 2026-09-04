extends CharacterBody2D
class_name Elena

signal arrived_at_destination
signal destination_reached(destination:Vector2)

@export_subgroup("References")
@export var state_machine : ElenaStateMachine
@export var interactable_component : InteractableComponent
@export var elena_sprite : ElenaSprite
@export var nav_agent : NavigationAgent2D
@export var interact_color_rect : ColorRect

@export_subgroup("Movement Settings")
@export var movement_speed : float = 200.0
@export var arrival_distance : float = 4.0

@export_subgroup("Rotation Settings")
## Higher = snappier turning. Set to 0 for instant rotation.
@export var rotation_speed : float = 10.0

@export_subgroup("Room Settings")
@export var initial_room : EnumUtility.RoomName

var current_room : EnumUtility.RoomName

var _target_position : Vector2
var _target_rotation : float = 0.0
var _pending_facing_rotation : float = NAN
var _has_arrived : bool = true
var _travel_id : int = 0
var _current_seat : Seat = null
var _is_seated : bool = false
var _pending_seat_rotation : float = 0.0
var _is_in_dialogue : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Connect signals
	if interactable_component:
		interactable_component.hovered.connect(_on_interactable_hovered)
		interactable_component.unhovered.connect(_on_interactable_unhovered)
		interactable_component.interacted.connect(_on_interactable_interacted)
	if nav_agent: nav_agent.velocity_computed.connect(_on_velocity_computed)
	# Initialize
	if nav_agent: nav_agent.max_speed = movement_speed
	if interact_color_rect: interact_color_rect.hide()
	_target_position = global_position
	_target_rotation = rotation
	current_room = initial_room

func _physics_process(delta: float) -> void:
	_do_movement(delta)
	_check_arrival()
	_do_rotation(delta)
	if elena_sprite: _do_animation()

# ==================================================================================================
#                Movement methods
# ==================================================================================================
func _do_movement(delta:float) -> void:
	if _is_seated or _is_in_dialogue:
		velocity = Vector2.ZERO
		return
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
	if _has_arrived: return
	var reached : bool = false
	if nav_agent: reached = nav_agent.is_navigation_finished()
	else: reached = global_position.distance_to(_target_position) <= arrival_distance
	if reached:
		_has_arrived = true
		global_position = _target_position
		velocity = Vector2.ZERO
		if _current_seat:
			_target_rotation = _pending_seat_rotation
			rotation = _pending_seat_rotation
			_is_seated = true
			if elena_sprite: elena_sprite.do_sit(_current_seat.is_sitting_legless)
		elif not is_nan(_pending_facing_rotation):
			_target_rotation = _pending_facing_rotation
		arrived_at_destination.emit()

func _do_rotation(delta:float) -> void:
	if velocity.length_squared() > 1.0: _target_rotation = velocity.angle()
	if rotation_speed <= 0.0: rotation = _target_rotation
	else: rotation = lerp_angle(rotation, _target_rotation, rotation_speed * delta)

func _do_animation():
	if _is_seated: return
	if velocity.length_squared() > 1.0: elena_sprite.do_walk()
	else: elena_sprite.do_idle()

func _move_to(new_position: Vector2, facing_rotation: float = NAN) -> void:
	_has_arrived = false
	_current_seat = null
	_pending_facing_rotation = facing_rotation
	_target_position = new_position
	if nav_agent: nav_agent.target_position = new_position

# ==================================================================================================
#                NPC methods
# ==================================================================================================
## Walks (through doors if needed) to destination in destination_room, optionally snapping to
## facing_degrees once arrived. Cancels any previous in-progress travel.
## Emits destination_reached once she physically arrives at `destination` (not intermediate door stops).
func go_to(
	destination:Vector2, destination_room:EnumUtility.RoomName, facing_degrees:float = NAN
) -> void:
	_travel_id += 1
	var travel_id : int = _travel_id
	await _travel_through_doors(destination_room, travel_id)
	if travel_id != _travel_id: return
	var facing_rotation : float = deg_to_rad(facing_degrees) if !is_nan(facing_degrees) else NAN
	_move_to(destination, facing_rotation)
	await arrived_at_destination
	if travel_id != _travel_id: return
	destination_reached.emit(destination)

## Walks (through doors if needed) to destination_room then calls interactable.npc_interact(self).
## Works for InteractableComponent.
func go_to_interactable(
	interactable:InteractableComponent, destination_room:EnumUtility.RoomName
) -> void:
	_travel_id += 1
	var travel_id : int = _travel_id
	await _travel_through_doors(destination_room, travel_id)
	if travel_id != _travel_id: return
	_move_to(interactable.get_position())
	await arrived_at_destination
	if travel_id != _travel_id: return
	destination_reached.emit(interactable.get_position())
	interactable.npc_interact(self)

## Stands up from whatever seat she's currently occupying, if any. Safe to call when not seated.
func stand_up_if_seated() -> void:
	if _current_seat:
		_current_seat.stand_up() # cascades back into Elena.stand_up()

## Called by Seat.sit_actor() once assigned — begins walking to the seat marker.
func sit_at(seat_position:Vector2, facing_rotation:float, is_legless:bool, seat:Seat) -> void:
	_has_arrived = false
	_current_seat = seat
	_is_seated = false
	_pending_seat_rotation = facing_rotation
	_target_position = seat_position
	if nav_agent: nav_agent.target_position = seat_position

## Called by Seat.stand_up() — clears seated state so she can move again.
func stand_up() -> void:
	_is_seated = false
	_current_seat = null

func is_seated() -> bool: return _is_seated

## Freezes all movement immediately and cancels any in-progress travel. Called when dialogue starts.
func enter_dialogue() -> void:
	_is_in_dialogue = true
	_travel_id += 1 # cancel any in-progress go_to/go_to_interactable coroutine
	_has_arrived = true
	_target_position = global_position
	if state_machine: state_machine.enter_dialogue_state()
	if elena_sprite: elena_sprite.do_idle()
	if nav_agent: nav_agent.target_position = global_position
	velocity = Vector2.ZERO

## Called when dialogue ends — allows movement again.
func exit_dialogue() -> void:
	_is_in_dialogue = false
	if state_machine: state_machine.exit_dialogue_state()

func is_in_dialogue() -> bool: return _is_in_dialogue

## Walks through whatever doors connect current_room to destination_room, updating current_room
## as she passes through each one. No-op if already in the destination room.
func _travel_through_doors(destination_room:EnumUtility.RoomName, travel_id:int) -> void:
	if destination_room == current_room: return
	var door_path : Array[Door]
	door_path = DoorManager.instance.find_door_path(current_room, destination_room)
	if door_path.is_empty():
		push_error("No door path from %s to %s" % [current_room, destination_room])
		return
	for door in door_path:
		if travel_id != _travel_id: return
		var from_push_side : bool = (current_room == door.push_side_room)
		var near_marker : Marker2D
		near_marker = door.push_side_marker if from_push_side else door.pull_side_marker
		var far_marker : Marker2D
		far_marker = door.pull_side_marker if from_push_side else door.push_side_marker
		_move_to(near_marker.global_position)
		await arrived_at_destination
		if travel_id != _travel_id: return
		door.open_for_transit(current_room)
		if travel_id != _travel_id: return
		_move_to(far_marker.global_position)
		await arrived_at_destination
		if travel_id != _travel_id: return
		current_room = door.pull_side_room if from_push_side else door.push_side_room

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered(): if interact_color_rect: interact_color_rect.show()

func _on_interactable_unhovered(): if interact_color_rect: interact_color_rect.hide()

func _on_interactable_interacted():
	enter_dialogue()
	DialogueManager.show_dialogue_balloon(DialogueUI.instance.dialogue_resource, "talk")
	await DialogueManager.dialogue_ended
	exit_dialogue()

func _on_velocity_computed(safe_velocity:Vector2) -> void:
	if _is_seated or _is_in_dialogue:
		velocity = Vector2.ZERO
		return
	velocity = safe_velocity
	move_and_slide()
