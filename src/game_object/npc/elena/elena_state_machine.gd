extends Node
class_name ElenaStateMachine

enum NPCState{
	COOKING,
	SERVING_FOOD,
	EATING,
	SITTING_SOFA,
	SHOWERING,
	DRESSING_UP,
	PUTTING_MAKEUP,
	PHONE_CALL,
	GOING_OUTSIDE,
	ON_DIALOGUE,
}

signal state_changed(state:NPCState)

@export_subgroup("References")
@export var npc : Elena

@export_subgroup("Schedule Settings")
## Maps how much game time minutes a state takes
@export var schedule_dictionary : Dictionary[NPCState, int] = {
	NPCState.COOKING:20,
	NPCState.SERVING_FOOD:10,
	NPCState.EATING:30,
	NPCState.SITTING_SOFA:60,
	NPCState.SHOWERING:60,
	NPCState.DRESSING_UP:90,
	NPCState.PUTTING_MAKEUP:10,
	NPCState.PHONE_CALL:20,
	NPCState.GOING_OUTSIDE:999999999,
}

@export_subgroup("State Settings")
@export var cooking_stove : Stove
@export var serving_food_marker : Marker2D
@export var serving_food_facing : float
@export var eating_seat_interactable : InteractableComponent
@export var sofa_seat_interactable : InteractableComponent
@export var showering_marker : Marker2D
@export var showering_facing : float
@export var showering_shower : Shower
@export var dressing_up_marker : Marker2D
@export var dressing_up_facing : float
@export var dressing_up_wardrobe : Wardrobe
@export var putting_makeup_seat_interactable : InteractableComponent
@export var phone_call_marker : Marker2D
@export var phone_call_facing : float
@export var going_outside_marker : Marker2D
@export var going_outside_facing : float

var current_state : NPCState
var previous_state : NPCState

## How long game minute time passed in current state
var _state_game_time_minute_timer : int = 0
## How much game minute time
var _change_state_game_time_minute : int

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(npc, "npc is missing")
	assert(!schedule_dictionary.is_empty(), "schedule_dictionary is empty")
	assert(cooking_stove, "cooking_stove is missing")
	assert(serving_food_marker, "serving_food_marker is missing")
	assert(eating_seat_interactable, "eating_seat_interactable is missing")
	assert(sofa_seat_interactable, "sofa_seat_interactable is missing")
	assert(showering_marker, "showering_marker is missing")
	assert(showering_shower, "showering_shower is missing")
	assert(dressing_up_marker, "dressing_up_marker is missing")
	assert(dressing_up_wardrobe, "dressing_up_wardrobe is missing")
	assert(putting_makeup_seat_interactable, "putting_makeup_seat_interactable is missing")
	assert(phone_call_marker, "phone_call_marker is missing")
	assert(going_outside_marker, "going_outside_marker is missing")
	assert(GameTimer.instance, "GameTimer.instance is missing")
	# Connect signals
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	_state_game_time_minute_timer = 0
	_change_state_game_time_minute = schedule_dictionary[current_state]
	_enter_state(current_state)


# ==================================================================================================
#                Dialogue methods
# ==================================================================================================
func enter_dialogue_state() -> void: change_state(NPCState.ON_DIALOGUE)

func exit_dialogue_state() -> void: change_state(previous_state)

# ==================================================================================================
#                State machine methods
# ==================================================================================================
func change_state(state:NPCState):
	# Change the state
	previous_state = current_state
	current_state = state
	_exit_state(previous_state)
	_enter_state(current_state)
	# Reset state timer if the state is new / not from dialogue
	if current_state != NPCState.ON_DIALOGUE and previous_state != NPCState.ON_DIALOGUE:
		_state_game_time_minute_timer = 0
		_change_state_game_time_minute = schedule_dictionary[current_state]
	# Emit signal
	state_changed.emit(current_state)

func _enter_state(state:NPCState) -> void:
	match state:
		NPCState.COOKING:
			npc.stand_up_if_seated()
			cooking_stove.turn_on()
		NPCState.SERVING_FOOD:
			npc.stand_up_if_seated()
			npc.go_to(
				serving_food_marker.global_position,
				EnumUtility.RoomName.MainRoom,
				serving_food_facing
			)
			await npc.destination_reached
			print("serving food")
		NPCState.EATING:
			npc.stand_up_if_seated()
			npc.go_to_interactable(eating_seat_interactable, EnumUtility.RoomName.MainRoom)
		NPCState.SITTING_SOFA:
			npc.stand_up_if_seated()
			npc.go_to_interactable(sofa_seat_interactable, EnumUtility.RoomName.MainRoom)
		NPCState.SHOWERING:
			npc.stand_up_if_seated()
			npc.go_to(
				showering_marker.global_position,
				EnumUtility.RoomName.Bathroom,
				showering_facing
			)
			await npc.destination_reached
			showering_shower.lock()
		NPCState.DRESSING_UP:
			npc.stand_up_if_seated()
			npc.go_to(
				dressing_up_marker.global_position,
				EnumUtility.RoomName.Bedroom,
				dressing_up_facing
			)
			await npc.destination_reached
			dressing_up_wardrobe.open()
		NPCState.PUTTING_MAKEUP:
			npc.stand_up_if_seated()
			npc.go_to_interactable(putting_makeup_seat_interactable, EnumUtility.RoomName.Bedroom)
		NPCState.PHONE_CALL:
			npc.stand_up_if_seated()
			npc.go_to(
				phone_call_marker.global_position,
				EnumUtility.RoomName.Bedroom,
				phone_call_facing
			)
		NPCState.GOING_OUTSIDE:
			npc.stand_up_if_seated()
			npc.go_to(
				going_outside_marker.global_position,
				EnumUtility.RoomName.MainRoom,
				going_outside_facing
			)
			await npc.destination_reached
			npc.queue_free()
		NPCState.ON_DIALOGUE: pass

func _exit_state(state:NPCState) -> void:
	match state:
		NPCState.COOKING:
			cooking_stove.turn_off()
		NPCState.SHOWERING:
			showering_shower.unlock()
		NPCState.DRESSING_UP:
			dressing_up_wardrobe.close()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_time_tick(game_time_minute:int) -> void:
	if current_state == NPCState.ON_DIALOGUE: return
	_state_game_time_minute_timer += 1
	if _state_game_time_minute_timer > _change_state_game_time_minute:
		change_state(current_state + 1)
