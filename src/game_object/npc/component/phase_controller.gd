extends Node
class_name PhaseController

## Sequence of phases for the NPC
@export var phase_array : Array[BasePhase]

var current_phase : BasePhase

var _current_phase_index : int = -1

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(!phase_array.is_empty(), "phase_array is empty")
	# Connect signals
	for phase:BasePhase in phase_array:
		phase.phase_finished.connect(_next_phase)
		phase.skipped_to_end.connect(skip_to_end_phase)
	# Initialize
	_next_phase()

# ==================================================================================================
#                Phase methods
# ==================================================================================================
func interupt_current_phase(): current_phase.interupt_phase()

func continue_current_phase(): current_phase.continue_phase()

func skip_to_end_phase():
	_current_phase_index = phase_array.size() - 1
	if current_phase: current_phase.end_phase()
	if _current_phase_index < phase_array.size():
		current_phase = phase_array[_current_phase_index]
		current_phase.start_phase()
	else:
		current_phase = null

func _next_phase():
	_current_phase_index += 1
	if current_phase: current_phase.end_phase()
	if _current_phase_index < phase_array.size():
		current_phase = phase_array[_current_phase_index]
		current_phase.start_phase()
	else:
		current_phase = null
