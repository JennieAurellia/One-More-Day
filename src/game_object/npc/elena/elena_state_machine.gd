extends Node
class_name ElenaStateMachine

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
	ON_DIALOGUE,
}

signal state_changed(state: NPCState)

@export_subgroup("References")
@export var npc : Elena

@export_subgroup("Schedule Settings")
## Maps game clock minute (e.g. 360 = 06:00) to the state the NPC enters at that time
@export var schedule_dictionary : Dictionary[int, NPCState] = {
	360:NPCState.COOKING,
	380:NPCState.SERVING_FOOD,
	390:NPCState.EATING,
	420:NPCState.SITTING_SOFA,
	480:NPCState.SHOWERING,
	540:NPCState.IN_BEDROOM,
	630:NPCState.DRESSING_UP,
	640:NPCState.PHONE_CALL,
	660:NPCState.GOING_OUTSIDE,
}
## Where the NPC should walk to for each state (optional — states with no entry just stay put)
@export var state_position_dictionary : Dictionary[NPCState, Marker2D]
## Facing angle (degrees) to snap to once arrived (ignored for states using state_interactable_dictionary)
@export var state_facing_dictionary : Dictionary[NPCState, float]
## Which room each state's destination is in (used to route through doors)
@export var state_room_dictionary : Dictionary[NPCState, EnumUtility.RoomName]
## States that should walk to and interact with an InteractableComponent
## (Seat sits, Door opens, or any custom npc_interact() override).
## Takes priority over state_position_dictionary.
@export var state_interactable_dictionary : Dictionary[NPCState, InteractableComponent]

var current_state : NPCState

var _sorted_schedule_times : Array[int]
var _state_before_talking : NPCState
var _is_talking : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(npc, "npc is missing")
	assert(!schedule_dictionary.is_empty(), "schedule_dictionary is empty")
	assert(GameTimer.instance, "GameTimer.instance is missing")
	# Connect signals
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	_sorted_schedule_times = schedule_dictionary.keys()
	_sorted_schedule_times.sort()
	_apply_state_for_minute(GameTimer.instance.get_game_time_minute())

# ==================================================================================================
#                State machine methods
# ==================================================================================================
func enter_dialogue_state() -> void:
	if _is_talking: return
	_is_talking = true
	_state_before_talking = current_state
	current_state = NPCState.ON_DIALOGUE
	state_changed.emit(NPCState.ON_DIALOGUE)

func exit_dialogue_state() -> void:
	if !_is_talking: return
	_is_talking = false
	# Re-apply whatever the schedule says *right now* rather than blindly resuming
	# the pre-talk state, in case the clock advanced past a state change while talking.
	_apply_state_for_minute(GameTimer.instance.get_game_time_minute())

func _enter_state(state:NPCState) -> void:
	npc.stand_up_if_seated()
	current_state = state
	var dest_room : EnumUtility.RoomName = state_room_dictionary.get(state, npc.current_room)
	if state_interactable_dictionary.has(state):
		npc.go_to_interactable(state_interactable_dictionary[state], dest_room)
	elif state_position_dictionary.has(state):
		var facing_degrees : float = state_facing_dictionary.get(state, NAN)
		npc.go_to(state_position_dictionary[state].global_position, dest_room, facing_degrees)
	state_changed.emit(state)

## Finds the most recent schedule entry at or before the given minute and enters that state.
## Used both for live ticks and for catching up on _ready() if the game starts mid-schedule.
func _apply_state_for_minute(minute:int) -> void:
	var applicable_time : int = -1
	for time:int in _sorted_schedule_times:
		if minute < time: break
		else: applicable_time = time
	if applicable_time != -1:
		_enter_state(schedule_dictionary[applicable_time])

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_time_tick(game_time_minute:int) -> void:
	if _is_talking: return
	if schedule_dictionary.has(game_time_minute):
		_enter_state(schedule_dictionary[game_time_minute])
