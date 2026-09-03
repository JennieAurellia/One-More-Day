extends Node2D
class_name ShowerFaucet

@export_subgroup("References")
@export var interactable_component : InteractableComponent

@export_subgroup("Shower Settings")
## How long the shower will be active
@export var active_game_time_minute : float = 60.0
@export var active_on_load : bool = true

var _is_active : bool = false
var _active_until_game_time_minute : float = 0.0

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(GameTimer.instance, "GameTimer.instance is missing")
	# Connect signals
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	turn_off()

# ==================================================================================================
#                Shower methods
# ==================================================================================================
func turn_on():
	print("showering")
	_is_active = true
	var current_game_time_minute : int = GameTimer.instance.get_game_time_minute()
	_active_until_game_time_minute =  current_game_time_minute + active_game_time_minute

func turn_off():
	print("shower finish")
	_is_active = false

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_interacted_by_npc(npc:Node) -> void:
	turn_on()

func _on_time_tick(game_time_minute:int) -> void:
	if !_is_active: return
	if game_time_minute >= _active_until_game_time_minute: turn_off()
