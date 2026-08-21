extends CharacterBody2D
class_name Player

@export_subgroup("References")
@export var nav_agent : NavigationAgent2D

@export_subgroup("Movement Settings")
@export var speed : float = 300.0
@export var arrival_distance : float = 4.0

@export_subgroup("Rotation Settings")
## Higher = snappier turning. Set to 0 for instant rotation.
@export var rotation_speed : float = 10.0

var target_position : Vector2

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Connect signals
	if nav_agent: nav_agent.velocity_computed.connect(_on_velocity_computed)
	# Initialize
	target_position = global_position

func _physics_process(delta: float) -> void:
	_do_movement(delta)
	_do_rotation(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if nav_agent: nav_agent.target_position = get_global_mouse_position()
			else: target_position = get_global_mouse_position()

# ==================================================================================================
#                Player methods
# ==================================================================================================
func _do_movement(delta:float):
	# Do movement with nav agent
	if nav_agent:
		if nav_agent.is_navigation_finished(): return
		var next_path_position : Vector2 = nav_agent.get_next_path_position()
		var direction : Vector2 = global_position.direction_to(next_path_position)
		var new_velocity : Vector2 = direction * speed
		nav_agent.set_velocity(new_velocity)
	# Do movement without nav agent
	else:
		if global_position.distance_to(target_position) > arrival_distance:
			var direction : Vector2 = (target_position - global_position).normalized()
			velocity = direction * speed
		else: velocity = Vector2.ZERO
		move_and_slide()

func _do_rotation(delta:float):
	# Rotate towards velocity
	if velocity.length_squared() < 1.0: return
	var target_angle : float = velocity.angle()
	if rotation_speed <= 0.0: rotation = target_angle
	else: rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
