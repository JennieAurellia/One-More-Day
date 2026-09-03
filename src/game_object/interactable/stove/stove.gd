extends Node2D
class_name Stove

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var cook_sprite : Sprite2D

@export_subgroup("Stove Settings")
## How long the stove will be active cooking
@export var active_game_time_minute : float = 20.0
@export var active_on_load : bool = true

var _is_active : bool = false
var _active_until_game_time_minute : float = 0.0

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(cook_sprite, "cook_sprite is missing")
	assert(GameTimer.instance, "GameTimer.instance is missing")
	# Connect signals
	interactable_component.interacted_by_npc.connect(_on_interactable_interacted_by_npc)
	GameTimer.instance.time_tick.connect(_on_time_tick)
	# Initialize
	if active_on_load: turn_on()
	else: turn_off()

# ==================================================================================================
#                Stove methods
# ==================================================================================================
func turn_on():
	cook_sprite.show()
	_is_active = true
	var current_game_time_minute : int = GameTimer.instance.get_game_time_minute()
	_active_until_game_time_minute =  current_game_time_minute + active_game_time_minute

func turn_off():
	cook_sprite.hide()
	_is_active = false

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_interacted_by_npc(npc:Node) -> void:
	turn_on()

func _on_time_tick(game_time_minute:int) -> void:
	if !_is_active: return
	if game_time_minute >= _active_until_game_time_minute: turn_off()
