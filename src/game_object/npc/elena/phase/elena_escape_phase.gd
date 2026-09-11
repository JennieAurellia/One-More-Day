extends BaseElenaPhase
class_name ElenaEscapePhase

enum State{
	## Elena is going outside
	ESCAPING,
}

@export_subgroup("Escaping Settings")
@export var outside_marker : Marker2D
@export var outside_facing : float

var current_state : State

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
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
		
		State.ESCAPING:
			elena.stand_up_if_seated()
			elena.go_to(
				outside_marker.global_position,
				EnumUtility.RoomName.OUTSIDE,
				outside_facing
			)
			await elena.destination_reached
			GameManager.restart_day() # Reset day

func exit_state(state:State): pass

func update_state(delta:float): pass
