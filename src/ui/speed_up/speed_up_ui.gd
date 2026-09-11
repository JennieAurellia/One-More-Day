extends Control
class_name SpeedUpUI

@export_subgroup("References")
@export var button : Button

@export_subgroup("Speed Up Settings")
@export var speed_up_scale : float = 3.0

var _is_speeding_up : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource):
		stop_speed_up()
		hide()
		)
	DialogueManager.dialogue_ended.connect(func(resource:DialogueResource): show())

func _process(delta: float) -> void:
	if button.button_pressed: start_speed_up()
	else: stop_speed_up()

# ==================================================================================================
#                Speed up methods
# ==================================================================================================
func start_speed_up():
	if _is_speeding_up: return
	_is_speeding_up = true
	Engine.time_scale = speed_up_scale

func stop_speed_up():
	if !_is_speeding_up: return
	_is_speeding_up = false
	Engine.time_scale = 1.0
