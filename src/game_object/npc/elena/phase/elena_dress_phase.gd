extends BaseElenaPhase
class_name ElenaDressPhase

enum State{
	## Elena is taking her phones
	TAKE_PHONE,
	## Elena is going to the wardrobe
	TO_WARDROBE,
	## Elena is wearing clothes
	DRESSING,
	## Elena is angry because player takes her phone
	ANGRY,
}

@export_subgroup("Take Phone Settings")
@export var take_phone_marker : Marker2D
@export var take_phone_facing : float
@export var elena_phone : ElenaPhone

@export_subgroup("To Wardrobe Settings")
@export var to_wardrobe_marker : Marker2D
@export var to_wardrobe_facing : float

@export_subgroup("Dressing Settings")
@export var dressing_wardrobe : Wardrobe
@export var dressing_time : float = 90.0

@export_subgroup("Angry Settings")
@export var outside_marker : Marker2D
@export var outside_facing : float

var current_state : State

var _dressing_timer : float

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(elena, "elena is missing")
	assert(take_phone_marker, "take_phone_marker is missing")
	assert(elena_phone, "elena_phone is missing")
	assert(to_wardrobe_marker, "to_wardrobe_marker is missing")
	assert(dressing_wardrobe, "dressing_wardrobe is missing")
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
		
		State.TAKE_PHONE:
			elena.stand_up_if_seated()
			elena.go_to(
				take_phone_marker.global_position,
				EnumUtility.RoomName.MAINROOM,
				take_phone_facing
			)
			await elena.destination_reached
			if elena_phone.is_phone_placed():
				elena_phone.take_phone()
				change_state(State.TO_WARDROBE)
			else:
				change_state(State.ANGRY)
		
		State.TO_WARDROBE:
			elena.go_to(
				to_wardrobe_marker.global_position,
				EnumUtility.RoomName.BEDROOM,
				to_wardrobe_facing
			)
			await elena.destination_reached
			change_state(State.DRESSING)
		
		State.DRESSING:
			dressing_wardrobe.open()
		
		State.ANGRY:
			elena.do_dialogue("caught_spying")
			await elena.dialogue_finished
			elena.go_to(
				outside_marker.global_position,
				EnumUtility.RoomName.OUTSIDE,
				outside_facing
			)
			# Stay stuck outside (end of flow)

func exit_state(state:State):
	match state:
		
		State.DRESSING:
			dressing_wardrobe.close()

func update_state(delta:float):
	match current_state:
		
		State.DRESSING:
			_dressing_timer += delta / GameTimer.instance.seconds_per_game_time_minute
			if _dressing_timer >= dressing_time and !is_interupted:
				exit_state(current_state)
				phase_finished.emit()
