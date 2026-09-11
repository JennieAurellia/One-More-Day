extends Node

@export_subgroup("References")
@export var outside_door : Door

@export_subgroup("Game Settings")
@export var reset_game_time_minute : float = 660

func _ready() -> void:
	# Assertion check
	assert(outside_door, "outside_door is missing")
	# Connect signals
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	InventoryManager.clear_inventory()
	AudioManager.play_music("game")
	outside_door.is_disabled = GameManager.loop_count <= 0

func _on_time_tick(game_time_minute:int):
	# Time reached for reset
	if game_time_minute >= reset_game_time_minute:
		# Not the first loop
		if GameManager.loop_count > 0:
			# Not proven successfully / ending
			if !EventFlag.instance.is_prove_successful:
				GameManager.restart_day()
