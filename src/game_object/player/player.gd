extends CharacterBody2D
class_name Player

@export_subgroup("References")
@export var nav_agent : NavigationAgent2D

@export_subgroup("Movement Settings")
@export var movement_speed : float = 300.0
@export var arrival_distance : float = 4.0

@export_subgroup("Rotation Settings")
## Higher = snappier turning. Set to 0 for instant rotation.
@export var rotation_speed : float = 10.0

@export_subgroup("Interaction Settings")
## How close the player needs to be to the interactable before it triggers.
@export var interact_distance : float = 40.0

var _target_position : Vector2
var _target_rotation : float = 0.0
var _is_about_to_interact : bool = false
var _pending_interactable : InteractableComponent = null

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Connect signals
	if nav_agent: nav_agent.velocity_computed.connect(_on_velocity_computed)
	# Initialize
	if nav_agent: nav_agent.max_speed = movement_speed
	_target_position = global_position
	_target_rotation = rotation

func _physics_process(delta: float) -> void:
	_do_movement(delta)
	_do_rotation(delta)
	_check_pending_interaction()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_left_mouse_interaction()

# ==================================================================================================
#                Player methods
# ==================================================================================================
func _do_movement(delta:float):
	# Do movement with nav agent
	if nav_agent:
		if nav_agent.is_navigation_finished(): return
		var next_path_position : Vector2 = nav_agent.get_next_path_position()
		var direction : Vector2 = global_position.direction_to(next_path_position)
		var new_velocity : Vector2 = direction * movement_speed
		nav_agent.set_velocity(new_velocity)
	# Do movement without nav agent
	else:
		if global_position.distance_to(_target_position) > arrival_distance:
			var direction : Vector2 = (_target_position - global_position).normalized()
			velocity = direction * movement_speed
		else: velocity = Vector2.ZERO
		move_and_slide()

func _do_rotation(delta:float):
	# Update target rotation only while actually moving
	if velocity.length_squared() > 1.0: _target_rotation = velocity.angle()
	# Always interpolate towards the target rotation, even after stopping
	if rotation_speed <= 0.0: rotation = _target_rotation
	else: rotation = lerp_angle(rotation, _target_rotation, rotation_speed * delta)

func _check_pending_interaction() -> void:
	if _pending_interactable == null: return
	if not is_instance_valid(_pending_interactable):
		_pending_interactable = null
		return
	if global_position.distance_to(_pending_interactable.get_position()) <= interact_distance:
		_pending_interactable.interact()
		_pending_interactable = null
		_move_to(global_position) # Stop the player right where they arrived

func _left_mouse_interaction():
	var hovered : InteractableComponent = InteractableComponent.current_hovered_interactable
	var selected : ItemData = InventoryManager.selected_item
	if hovered:
		# Walk to the interactable first, interact once close enough
		_pending_interactable = hovered
		_move_to(hovered.get_position())
	elif selected:
		# Deselect item when clicked at empty space
		InventoryManager.select_item(null)
	else:
		# Regular point-and-click movement, cancel any pending interaction
		_pending_interactable = null
		_move_to(get_global_mouse_position())

func _move_to(new_position:Vector2):
	if nav_agent: nav_agent.target_position = new_position
	else: _target_position = new_position

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
