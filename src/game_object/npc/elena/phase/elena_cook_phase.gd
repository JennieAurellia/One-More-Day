extends BaseElenaPhase
class_name ElenaCookPhase

enum State{
	## Elena cooking in kitchen
	COOKING,
	## Elena serving food after cooking
	SERVING,
	## Elena calling Adrian if he has not exited bedroom
	CALLING,
}

@export_subgroup("Cooking Settings")
@export var cooking_stove : Stove
@export var cooking_time : float = 20.0

@export_subgroup("Serving Settings")
@export var serving_marker : Marker2D
@export var serving_facing : float
@export var serving_dining_table : DiningTable
@export var serving_time : float = 10.0

@export_subgroup("Calling Settings")
@export var calling_marker : Marker2D
@export var calling_facing : float

var current_state : State

var _cooking_timer : float
var _serving_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(cooking_stove, "cooking_stove is missing")
	assert(serving_marker, "serving_marker is missing")
	assert(serving_dining_table, "serving_dining_table is missing")
	assert(calling_marker, "calling_marker is missing")
	# Connect signals
	EventFlag.instance.exited_bedroom.connect(_on_exited_bedroom)

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
		
		State.COOKING:
			elena.stand_up_if_seated()
			cooking_stove.turn_on()
		
		State.SERVING:
			elena.stand_up_if_seated()
			elena.go_to(
				serving_marker.global_position,
				EnumUtility.RoomName.MAINROOM,
				serving_facing
			)
			await elena.destination_reached
			serving_dining_table.place_breakfast()
		
		State.CALLING:
			elena.go_to(
				calling_marker.global_position,
				EnumUtility.RoomName.BEDROOM,
				calling_facing
			)
			await elena.destination_reached
			elena.do_dialogue("still_inside_bedroom")
			await elena.dialogue_finished
			phase_finished.emit()

func exit_state(state:State):
	match state:
		
		State.COOKING:
			cooking_stove.turn_off()
		
		State.SERVING:
			EventFlag.instance.has_ate_breakfast = true

func update_state(delta:float):
	match current_state:
		
		State.COOKING:
			_cooking_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _cooking_timer >= cooking_time and !is_interupted: change_state(State.SERVING)
		
		State.SERVING:
			_serving_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _serving_timer >= serving_time and !is_interupted:
				if EventFlag.instance.has_exited_bedroom: phase_finished.emit()
				else: change_state(State.CALLING)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_exited_bedroom():
	if !is_active: return
	if EventFlag.instance.has_talked_before_breakfast: return
	if current_state == State.COOKING: elena.do_dialogue("still_cooking")
	else: elena.do_dialogue("after_cooking")
	EventFlag.instance.has_talked_before_breakfast = true
