extends Node

## Handles scene loading and change

const LOADING_LERP_SPEED : int = 10
const CHANGING_SCENE_DELAY_TIME : float = 0.5

# Scene node variables
@export var loading_scene : Control
@export var loading_progress_bar : ProgressBar

# Node reference
@onready var _animation : AnimationPlayer = $Animation
# Scene loading variables
var _load_scene_path : String
var _loading_progress_array : Array[float] = [] ## Value inside array is between 0.0 to 1.0
var _current_loading_progress : float = 0.0

# ================================================================================
#           Virtual methods
# ================================================================================
func _ready():
	set_process(false)
	loading_scene.visible = false

func _process(delta:float):
	# Get loading progress
	var loading_status : ResourceLoader.ThreadLoadStatus
	loading_status = ResourceLoader.load_threaded_get_status(_load_scene_path, _loading_progress_array)
	# Display loading progress
	var lerp_weight : float = delta * LOADING_LERP_SPEED
	_current_loading_progress = lerpf(_current_loading_progress, _loading_progress_array[0], lerp_weight)
	if loading_progress_bar: loading_progress_bar.value = _current_loading_progress
	# Change to the new scene after scene loaded
	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		if loading_progress_bar: loading_progress_bar.value = 1.0
		await get_tree().create_timer(CHANGING_SCENE_DELAY_TIME).timeout
		var loaded_scene : PackedScene = ResourceLoader.load_threaded_get(_load_scene_path)
		if get_tree().change_scene_to_packed(loaded_scene) != OK:
			push_error("Error occurred while changing scene")
		# Play fade out animation
		_animation.play("fade_out")
		await _animation.animation_finished
		#_close_loading_scene()

# ================================================================================
#           Public methods
# ================================================================================
func change_scene(new_scene_path:String):
	# Play fade in animation
	if loading_progress_bar: loading_progress_bar.value = 0
	_animation.play("fade_in")
	await _animation.animation_finished
	# Create and change to empty scene
	var empty_packed_scene : PackedScene = PackedScene.new()
	empty_packed_scene.pack(Node.new())
	get_tree().change_scene_to_packed(empty_packed_scene)
	# Prepare and load new scene
	_load_scene_path = new_scene_path
	ResourceLoader.load_threaded_request(new_scene_path)
	set_process(true)

# ================================================================================
#           Private methods
# ================================================================================
func _open_loading_scene():
	loading_scene.visible = true

func _close_loading_scene():
	loading_scene.visible = false
