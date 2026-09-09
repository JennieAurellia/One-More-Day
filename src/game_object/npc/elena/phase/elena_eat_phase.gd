extends BaseElenaPhase
class_name ElenaEatPhase

enum State{
	## Elena is going to eat breakfast
	EATING,
	## Elena want to talk while eating
	TALKING,
}

@export_subgroup("Eating Settings")
@export var eating_time : float = 15.0
@export var eating_seat_1 : Seat
@export var eating_seat_2 : Seat
@export var eating_breakfast_1 : Breakfast
@export var eating_breakfast_2 : Breakfast

@export_subgroup("Talking Settings")
@export var talking_time : float = 15.0

var current_state : State

var _current_breakfast : Breakfast
var _eating_timer : float
var _talking_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(eating_seat_1, "eating_seat_1 is missing")
	assert(eating_seat_2, "eating_seat_2 is missing")

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
		
		State.EATING:
			elena.stand_up_if_seated()
			EventFlag.instance.is_breakfast_eatable = true
			if !eating_seat_1.is_occupied():
				_current_breakfast = eating_breakfast_1
				elena.go_to_interactable(
					eating_seat_1.interactable_component, EnumUtility.RoomName.MAINROOM
				)
			else:
				_current_breakfast = eating_breakfast_2
				elena.go_to_interactable(
					eating_seat_2.interactable_component, EnumUtility.RoomName.MAINROOM
				)

func exit_state(state:State):
	match state:
		
		State.EATING:
			_current_breakfast.eat()

func update_state(delta:float):
	match current_state:
		
		State.EATING:
			_eating_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _eating_timer >= eating_time and !is_interupted: change_state(State.TALKING)
		
		State.TALKING:
			# Check for talk
			if !EventFlag.instance.has_talked_after_breakfast:
				if Camera.instance.current_room == EnumUtility.RoomName.MAINROOM:
					if EventFlag.instance.has_ate_breakfast: elena.do_dialogue("done_eating")
					else: elena.do_dialogue("not_eating")
					EventFlag.instance.has_talked_after_breakfast = true
			# Update timer
			_talking_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _talking_timer >= talking_time and !is_interupted: phase_finished.emit()
