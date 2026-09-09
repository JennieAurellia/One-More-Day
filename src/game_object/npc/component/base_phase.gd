@abstract extends  Node
class_name BasePhase

signal phase_finished

var is_active : bool = false
var is_interupted : bool = false

func start_phase():
	is_active = true
	initialize_phase()

func end_phase(): is_active = false

@abstract func initialize_phase()

## Interupt phase flow
@abstract func interupt_phase()

## Continue phase flow if currently inteupted
@abstract func continue_phase()
