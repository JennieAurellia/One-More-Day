extends Node

const TUTORIAL_DELAY_DURATION : float = 1.0

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
	if !EventFlag.has_seen_tutorial:
		await get_tree().create_timer(TUTORIAL_DELAY_DURATION).timeout
		HintUI.instance.show_tutorial_hint()
		EventFlag.has_seen_tutorial = true

func _on_time_tick(game_time_minute:int):
	# Time reached for reset
	if game_time_minute >= reset_game_time_minute:
		# Not the first loop
		if GameManager.loop_count > 0:
			# Not proven successfully / ending
			if !EventFlag.instance.is_prove_successful:
				GameManager.restart_day()
