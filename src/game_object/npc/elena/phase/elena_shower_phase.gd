extends BaseElenaPhase
class_name ElenaShowerPhase

enum State{
	## Elena want to talk before going to shower
	TALKING,
	## Elena is placing down her phone
	PLACE_PHONE,
	## Elena is going to the shower
	TO_SHOWER,
	## Elena is showering
	SHOWERING,
}

@export_subgroup("Place Phone Settings")
@export var place_phone_marker : Marker2D
@export var place_phone_facing : float
@export var elena_phone : ElenaPhone

@export_subgroup("To Shower Settings")
@export var to_shower_marker : Marker2D
@export var to_shower_facing : float

@export_subgroup("Showering Settings")
@export var showering_shower : Shower
@export var showering_time : float = 60.0

var current_state : State

var _showering_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(place_phone_marker, "place_phone_marker is missing")
	assert(elena_phone, "elena_phone is missing")
	assert(to_shower_marker, "to_shower_marker is missing")
	assert(showering_shower, "showering_shower is missing")

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
		
		State.TALKING:
			if Camera.instance.current_room == EnumUtility.RoomName.MAINROOM:
				elena.do_dialogue("going_to_shower")
				await elena.dialogue_finished
			change_state(State.PLACE_PHONE)
		
		State.PLACE_PHONE:
			elena.stand_up_if_seated()
			elena.go_to(
				place_phone_marker.global_position,
				EnumUtility.RoomName.MAINROOM,
				place_phone_facing
			)
			await elena.destination_reached
			elena_phone.place_phone()
			change_state(State.TO_SHOWER)
		
		State.TO_SHOWER:
			elena.go_to(
				to_shower_marker.global_position,
				EnumUtility.RoomName.BATHROOM,
				to_shower_facing
			)
			await elena.destination_reached
			change_state(State.SHOWERING)
		
		State.SHOWERING:
			showering_shower.lock()

func exit_state(state:State):
	match state:
		
		State.SHOWERING:
			showering_shower.unlock()

func update_state(delta:float):
	match current_state:
		
		State.SHOWERING:
			_showering_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _showering_timer >= showering_time and !is_interupted:
				exit_state(current_state)
				phase_finished.emit()
