extends Node2D
class_name Door

@export_subgroup("References")
@export var interactable_component : InteractableComponent
@export var rotate_pivot : Node2D
@export var sprite : Sprite2D
@export var push_side_marker : Marker2D
@export var pull_side_marker : Marker2D

@export_subgroup("Interact Settings")
@export var normal_color : Color = Color.WHITE
@export var hover_color : Color = Color.YELLOW

@export_subgroup("Door Settings")
@export var push_side_room : EnumUtility.RoomName
@export var pull_side_room : EnumUtility.RoomName

@export_subgroup("Swing Settings")
@export var swing_angle_degrees : float = 90.0
@export var swing_open_duration : float = 0.3
@export var swing_close_duration : float = 0.4
@export var swing_hold_duration : float = 0.2
@export var swing_open_trans : Tween.TransitionType = Tween.TRANS_BACK
@export var swing_close_trans : Tween.TransitionType = Tween.TRANS_SINE

var _swing_tween : Tween

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(interactable_component, "interactable_component is missing")
	assert(sprite, "sprite is missing")
	assert(push_side_marker, "push_side_marker is missing")
	assert(pull_side_marker, "pull_side_marker is missing")
	assert(
		push_side_room != pull_side_room, "push_side_room and pull_side_room are the same"
	)
	assert(rotate_pivot, "rotate_pivot is missing")
	# Connect signals
	interactable_component.interactable_hovered.connect(_on_interactable_hovered)
	interactable_component.interactable_unhovered.connect(_on_interactable_unhovered)
	interactable_component.interactable_interacted.connect(_on_interactable_interacted)
	interactable_component.item_used_on.connect(_on_item_used_on)

# ==================================================================================================
#                Door methods
# ==================================================================================================
func _move_player_to_push_side():
	Player.instance.move_to_position(push_side_marker.global_position)

func _move_player_to_pull_side():
	Player.instance.move_to_position(pull_side_marker.global_position)

func _play_swing(from_push_side:bool) -> void:
	# Clear tween
	if _swing_tween and _swing_tween.is_valid(): _swing_tween.kill()
	# Push side opens the door away (negative), pull side swings it towards (positive)
	var open_angle : float = deg_to_rad(swing_angle_degrees) * (-1.0 if from_push_side else 1.0)
	# Do swing tween
	rotate_pivot.rotation = 0.0
	_swing_tween = create_tween()
	_swing_tween.set_trans(swing_open_trans)
	_swing_tween.set_ease(Tween.EASE_OUT)
	_swing_tween.tween_property(rotate_pivot, "rotation", open_angle, swing_open_duration)
	_swing_tween.tween_interval(swing_hold_duration)
	_swing_tween.set_trans(swing_close_trans)
	_swing_tween.set_ease(Tween.EASE_IN_OUT)
	_swing_tween.tween_property(rotate_pivot, "rotation", 0.0, swing_close_duration)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_interactable_hovered(): sprite.modulate = hover_color

func _on_interactable_unhovered(): sprite.modulate = normal_color

func _on_interactable_interacted():
	if Camera.instance.current_room == push_side_room:
		_play_swing(true)
		Camera.instance.change_to_room(pull_side_room)
		RoomFog.instance.change_to_room(pull_side_room)
		call_deferred("_move_player_to_pull_side")
	elif Camera.instance.current_room == pull_side_room:
		_play_swing(false)
		Camera.instance.change_to_room(push_side_room)
		RoomFog.instance.change_to_room(push_side_room)
		call_deferred("_move_player_to_push_side")
	else:
		push_error("Room '%s' not found in Door Settings" % Camera.instance.current_room)

func _on_item_used_on(item_data:ItemData):
	pass
