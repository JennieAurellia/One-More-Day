extends CanvasLayer

@export var fade_duration : float = 0.5
@export var fade_trans : Tween.TransitionType = Tween.TRANS_SINE
@export var fade_ease : Tween.EaseType = Tween.EASE_IN_OUT

var _is_transitioning : bool = false
var _snapshot_rect : TextureRect
var _black_rect : ColorRect

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
#                Snapshot methods
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

# ==================================================================================================
#                Freeze frame methods
# ==================================================================================================
## Captures the current frame and holds it in place (fully opaque, blocking input)
## until unfreeze_frame() is called. Useful for pausing on a still image while
## doing work in the background (e.g. loading) without an automatic fade.
func freeze_frame() -> void:
	if _is_transitioning: return
	if is_instance_valid(_snapshot_rect): return # already frozen
	_capture_snapshot()
	_snapshot_rect.modulate.a = 1.0

## Removes the frozen frame instantly (no fade). Use fade_out_snapshot-style
## behavior manually if you want a smooth transition back instead.
func unfreeze_frame() -> void:
	if not is_instance_valid(_snapshot_rect): return
	_snapshot_rect.queue_free()
	_snapshot_rect = null

## Freezes the current frame, runs on_hidden while frozen, then fades the
## frozen frame away to reveal whatever on_hidden changed. Handy when you need
## to do something during the freeze (e.g. an async load) before releasing it.
func freeze_frame_and_call(on_hidden:Callable) -> void:
	if _is_transitioning: return
	_is_transitioning = true
	freeze_frame()
	await get_tree().process_frame
	if on_hidden.is_valid():
		await on_hidden.call()
	await get_tree().process_frame
	await _fade_out_snapshot()
	_is_transitioning = false

# ==================================================================================================
#                Black fade methods
# ==================================================================================================
## Fades the screen to black, runs on_hidden (do your scene change/reload here),
## then fades back in from black to reveal the new scene.
func fade_to_black_and_call(on_hidden:Callable) -> void:
	if _is_transitioning: return
	_is_transitioning = true
	await fade_out_to_black()
	on_hidden.call()
	await get_tree().process_frame
	await fade_in_from_black()
	_is_transitioning = false

## Use a fade-to-black transition to reload the current scene.
func fade_to_black_and_reload_scene() -> void:
	fade_to_black_and_call(func(): get_tree().reload_current_scene())

## Use a fade-to-black transition to change to a specific scene file.
func fade_to_black_and_change_scene(scene_path: String) -> void:
	fade_to_black_and_call(func(): get_tree().change_scene_to_file(scene_path))

## Fades a black overlay in (screen goes black). Leaves the overlay in place.
func fade_out_to_black() -> void:
	_ensure_black_rect()
	_black_rect.modulate.a = 0.0
	_black_rect.show()
	var tween := create_tween()
	tween.set_trans(fade_trans)
	tween.set_ease(fade_ease)
	tween.tween_property(_black_rect, "modulate:a", 1.0, fade_duration)
	await tween.finished

## Fades the black overlay out (screen becomes visible again).
func fade_in_from_black() -> void:
	_ensure_black_rect()
	_black_rect.modulate.a = 1.0
	_black_rect.show()
	var tween := create_tween()
	tween.set_trans(fade_trans)
	tween.set_ease(fade_ease)
	tween.tween_property(_black_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	_black_rect.hide()

func _ensure_black_rect() -> void:
	if is_instance_valid(_black_rect): return
	_black_rect = ColorRect.new()
	_black_rect.color = Color.BLACK
	_black_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_black_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	_black_rect.hide()
	add_child(_black_rect)
