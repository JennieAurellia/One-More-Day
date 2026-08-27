extends CanvasLayer

@export var fade_duration : float = 0.5
@export var fade_trans : Tween.TransitionType = Tween.TRANS_SINE
@export var fade_ease : Tween.EaseType = Tween.EASE_IN_OUT

var _is_transitioning : bool = false
var _snapshot_rect : TextureRect

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	layer = 128 # Draw on top of everything

# ==================================================================================================
#                Transition methods
# ==================================================================================================
## Use crossfade transition to reload the current scene.
func crossfade_and_reload_scene() -> void:
	_crossfade_and_call(func(): get_tree().reload_current_scene())

## Use crossfade transition to change to a specific scene file.
func crossfade_and_change_scene(scene_path: String) -> void:
	_crossfade_and_call(func(): get_tree().change_scene_to_file(scene_path))

## Freezes the current frame, runs on_hidden (do your scene change/reload here),
## then crossfades the frozen frame away to reveal the new scene.
func _crossfade_and_call(on_hidden:Callable) -> void:
	if _is_transitioning: return
	_is_transitioning = true
	_capture_snapshot()
	await get_tree().process_frame
	on_hidden.call()
	await get_tree().process_frame
	await _fade_out_snapshot()
	_is_transitioning = false

# ==================================================================================================
#                snapshot methods
# ==================================================================================================
func _capture_snapshot() -> void:
	var img : Image = get_viewport().get_texture().get_image()
	var snapshot_tex : ImageTexture = ImageTexture.create_from_image(img)
	_snapshot_rect = TextureRect.new()
	_snapshot_rect.texture = snapshot_tex
	_snapshot_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_snapshot_rect.stretch_mode = TextureRect.STRETCH_SCALE
	_snapshot_rect.mouse_filter = Control.MOUSE_FILTER_STOP # block clicks during transition
	add_child(_snapshot_rect)

func _fade_out_snapshot() -> void:
	if not is_instance_valid(_snapshot_rect): return
	var tween := create_tween()
	tween.set_trans(fade_trans)
	tween.set_ease(fade_ease)
	tween.tween_property(_snapshot_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	_snapshot_rect.queue_free()
	_snapshot_rect = null
