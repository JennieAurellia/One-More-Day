extends Node
class_name GameTimer

signal time_tick(game_time_minute:int)

static var instance : GameTimer

@export_subgroup("Game Time Settings")
## How much real seconds passed for one game time minute
@export var seconds_per_game_time_minute : float = 1.0
## The clock time (in total minutes since midnight) that the game starts at
@export var starting_game_time_minute : int = 360

var _elapsed_time : float
var _last_ticked_minute : int = -1

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

func _process(delta: float) -> void:
	_elapsed_time += delta
	_check_time_tick()

# ==================================================================================================
#                Game timer methods
# ==================================================================================================
func get_clock_time() -> String:
	var total_minutes : int = _get_total_clock_minutes()
	var hour : int = total_minutes / 60
	var minute : int = total_minutes % 60
	return "%02d:%02d" % [hour, minute]

func get_game_time_minute() -> int:
	return floor(_elapsed_time / seconds_per_game_time_minute)

func _get_total_clock_minutes() -> int:
	return (starting_game_time_minute + get_game_time_minute()) % (24 * 60)

func _check_time_tick() -> void:
	var current_minute : int = _get_total_clock_minutes()
	if current_minute != _last_ticked_minute:
		_last_ticked_minute = current_minute
		time_tick.emit(current_minute)
