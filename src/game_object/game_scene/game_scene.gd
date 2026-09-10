extends Node

@export var reset_game_time_minute : float = 660

func _ready() -> void:
	GameTimer.instance.time_tick.connect(_on_time_tick)
	GameManager.initialize_game()
	EventFlag.instance.reset_event()
	AudioManager.play_music("game")

func _on_time_tick(game_time_minute:int):
	if game_time_minute >= reset_game_time_minute: GameManager.restart_day()
