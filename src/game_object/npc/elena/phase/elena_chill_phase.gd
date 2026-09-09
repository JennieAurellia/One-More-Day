extends BaseElenaPhase
class_name ElenaChillPhase

enum State{
	## Elena is going to sofa
	CHILLING,
	## Elena want to talk while chilling
	TALKING,
}

@export_subgroup("Chilling Settings")
@export var chilling_sofa_seat_array : Array[Seat]

@export_subgroup("Talking Settings")
@export var talking_time : float = 30.0

var current_state : State

var _talking_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(!chilling_sofa_seat_array.is_empty(), "chilling_sofa_seat_array is empty")

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
		
		State.CHILLING:
			elena.stand_up_if_seated()
			var sofa_seat : Seat
			for seat:Seat in chilling_sofa_seat_array:
				if !seat.is_occupied():
					sofa_seat = seat
					break
			elena.go_to_interactable(
				sofa_seat.interactable_component, EnumUtility.RoomName.MAINROOM
			)
			await elena.destination_reached
			change_state(State.TALKING)

func exit_state(state:State): pass

func update_state(delta:float):
	match current_state:
		
		State.TALKING:
			# Check for talk
			if !EventFlag.instance.has_talked_while_chilling:
				if elena.is_seated() and EventFlag.instance.is_sitting_on_sofa:
					elena.do_dialogue("in_sofa")
					EventFlag.instance.has_talked_while_chilling = true
			# Update timer
			_talking_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _talking_timer >= talking_time and !is_interupted: phase_finished.emit()
