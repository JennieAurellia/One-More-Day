extends BaseElenaPhase
class_name ElenaReadyPhase

enum State{
	## Elena is is going to the make up desk
	TO_MAKE_UP,
	## Elena is putting make up
	PUTTING_MAKE_UP,
	## Elena is calling her friend
	CALLING_FRIEND,
	## Elena is going outside
	TO_OUTSIDE,
}

@export_subgroup("To Make Up Settings")
@export var to_make_up_seat : Seat

@export_subgroup("Putting Make Up Settings")
@export var putting_make_up_time : float = 10.0

@export_subgroup("Calling Friend Settings")
@export var calling_friend_marker : Marker2D
@export var calling_friend_facing : float
@export var calling_friend_time : float = 20.0

@export_subgroup("To Outside Settings")
@export var outside_marker : Marker2D
@export var outside_facing : float

var current_state : State

var _putting_make_up_timer : float
var _calling_friend_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(to_make_up_seat, "to_make_up_seat is missing")
	assert(calling_friend_marker, "calling_friend_marker is missing")
	assert(outside_marker, "outside_marker is missing")

func _process(delta: float) -> void: if is_active: update_state(delta)

# ==================================================================================================
#                Phase methods
# ==================================================================================================
func initialize_phase():
	enter_state(current_state)

func interupt_phase():
	is_interupted = true

func continue_phase():
	is_interupted = false

# ==================================================================================================
#                State methods
# ==================================================================================================
func change_state(new_state:State):
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)

func enter_state(state:State):
	match state:
		
		State.TO_MAKE_UP:
			elena.stand_up_if_seated()
			elena.go_to_interactable(
				to_make_up_seat.interactable_component, EnumUtility.RoomName.BEDROOM
			)
			await elena.destination_reached
			change_state(State.PUTTING_MAKE_UP)
		
		State.CALLING_FRIEND:
			elena.stand_up_if_seated()
			elena.go_to(
				calling_friend_marker.global_position,
				EnumUtility.RoomName.BEDROOM,
				calling_friend_facing
			)
		
		State.TO_OUTSIDE:
			elena.go_to(
				outside_marker.global_position,
				EnumUtility.RoomName.OUTSIDE,
				outside_facing
			)
			# Stay stuck outside (end of flow)

func exit_state(state:State): pass

func update_state(delta:float):
	match current_state:
		
		State.PUTTING_MAKE_UP:
			_putting_make_up_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _putting_make_up_timer >= putting_make_up_time and !is_interupted:
				change_state(State.CALLING_FRIEND)
		
		State.CALLING_FRIEND:
			_calling_friend_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _calling_friend_timer >= calling_friend_time and !is_interupted:
				change_state(State.TO_OUTSIDE)
