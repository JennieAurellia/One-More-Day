extends Control
class_name GameTimerUI

@export_subgroup("References")
@export var time_label : Label

func _ready() -> void:
	assert(time_label, "time_label is missing")

func _process(delta: float) -> void:
	if GameTimer.instance: time_label.text = GameTimer.instance.get_clock_time()
