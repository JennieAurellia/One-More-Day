extends Node2D
class_name Door

signal door_opened
signal door_closed

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var push_side_door_sprite : Sprite2D
@export var pull_side_door_sprite : Sprite2D
@export var push_side_opened_sprite : Sprite2D
@export var pull_side_opened_sprite : Sprite2D
@export var push_side_marker : Marker2D
@export var pull_side_marker : Marker2D

@export_subgroup("Interact Settings")
@export var normal_color : Color = Color.WHITE
@export var hover_color : Color = Color.YELLOW

@export_subgroup("Door Settings")
@export var push_side_room : EnumUtility.RoomName
@export var pull_side_room : EnumUtility.RoomName
@export var door_opened_duration : float = 0.3

var _is_open : bool = false

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _exit_tree() -> void:
	if DoorManager.instance: DoorManager.instance.unregister_door(self)

func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(push_side_door_sprite, "push_side_opened_sprite is missing")
	assert(pull_side_door_sprite, "pull_side_door_sprite is missing")
	assert(push_side_opened_sprite, "push_side_opened_sprite is missing")
	assert(pull_side_opened_sprite, "pull_side_opened_sprite is missing")
	assert(push_side_marker, "push_side_marker is missing")
	assert(pull_side_marker, "pull_side_marker is missing")
	assert(
		push_side_room != pull_side_room, "push_side_room and pull_side_room are the same"
	)
	# Connect signals
	interactable_component.hovered.connect(_on_interactable_hovered)
	interactable_component.unhovered.connect(_on_interactable_unhovered)
	interactable_component.interacted.connect(_on_interactable_interacted)
	interactable_component.item_used_on.connect(_on_interactable_item_used_on)
	# Initialize
	push_side_opened_sprite.hide()
	pull_side_opened_sprite.hide()
	DoorManager.instance.register_door(self)

# ==================================================================================================
#                Door methods
# ==================================================================================================
## For NPCs: opens the door (no camera/fog change) and returns once safe to walk through.
func open_for_transit(from_room: EnumUtility.RoomName) -> void:
	_play_door_open()

func _move_player_to_push_side():
	Player.instance.move_to_position(push_side_marker.global_position)

func _move_player_to_pull_side():
	Player.instance.move_to_position(pull_side_marker.global_position)

func _play_door_open() -> void:
	# Check and update _is_open
	if _is_open: return
	_is_open = true
	# Show door opened sprite
	push_side_opened_sprite.show()
	pull_side_opened_sprite.show()
	door_opened.emit()
	# Wait for door_opened_duration
	await get_tree().create_timer(door_opened_duration).timeout
	# Close door
	push_side_opened_sprite.hide()
	pull_side_opened_sprite.hide()
	_is_open = false
	door_closed.emit()

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered():
	push_side_door_sprite.modulate = hover_color
	pull_side_door_sprite.modulate = hover_color

func _on_interactable_unhovered():
	push_side_door_sprite.modulate = normal_color
	pull_side_door_sprite.modulate = normal_color

func _on_interactable_interacted():
	if Camera.instance.current_room == push_side_room:
		_play_door_open()
		Camera.instance.change_to_room(pull_side_room)
		RoomFog.instance.change_to_room(pull_side_room)
		call_deferred("_move_player_to_pull_side")
	elif Camera.instance.current_room == pull_side_room:
		_play_door_open()
		Camera.instance.change_to_room(push_side_room)
		RoomFog.instance.change_to_room(push_side_room)
		call_deferred("_move_player_to_push_side")
	else:
		push_error("Room '%s' not found in Door Settings" % Camera.instance.current_room)

func _on_interactable_item_used_on(item_data:ItemData):
	pass
