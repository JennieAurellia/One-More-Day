extends Control
class_name GameTimerUI

@export_subgroup("References")
@export var time_label : Label

func _ready() -> void:
	assert(time_label, "time_label is missing")
	DialogueManager.dialogue_started.connect(func(resource:DialogueResource): hide())
	DialogueManager.dialogue_ended.connect(func(resource:DialogueResource): show())

func _process(delta: float) -> void:
	if GameTimer.instance: time_label.text = GameTimer.instance.get_clock_time()
