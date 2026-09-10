extends Control
class_name SettingsUI

@export_subgroup("References")
@export var music_slider : HSlider
@export var music_progress_bar : TextureProgressBar
@export var sfx_slider : HSlider
@export var sfx_progress_bar : TextureProgressBar
@export var fullscreen_check : CheckBox
@export var vsync_check : CheckBox

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	# Assertion check
	assert(music_slider, "music_slider is missing")
	assert(music_progress_bar, "music_progress_bar is missing")
	assert(sfx_slider, "sfx_slider is missing")
	assert(sfx_progress_bar, "sfx_progress_bar is missing")
	assert(fullscreen_check, "fullscreen_check is missing")
	assert(vsync_check, "vsync_check is missing")
	# Connect signals
	SettingsManager.music_volume_changed.connect(_on_music_volume_changed)
	SettingsManager.sfx_volume_changed.connect(_on_sfx_volume_changed)
	SettingsManager.fullscreen_changed.connect(_on_fullscreen_changed)
	SettingsManager.vsync_changed.connect(_on_vsync_changed)
	# Initialize
	_setup_audio_controls()
	_setup_display_controls()

# ==================================================================================================
#                Setup methods
# ==================================================================================================
func _setup_audio_controls() -> void:
	music_slider.value = SettingsManager.music_volume
	music_progress_bar.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	sfx_progress_bar.value = SettingsManager.sfx_volume
	music_slider.value_changed.connect(SettingsManager.set_music_volume)
	music_slider.value_changed.connect(_update_music_progress_bar)
	sfx_slider.value_changed.connect(SettingsManager.set_sfx_volume)
	sfx_slider.value_changed.connect(_update_sfx_progress_bar)

func _setup_display_controls() -> void:
	fullscreen_check.button_pressed = SettingsManager.fullscreen
	vsync_check.button_pressed = SettingsManager.vsync
	fullscreen_check.toggled.connect(SettingsManager.set_fullscreen)
	vsync_check.toggled.connect(SettingsManager.set_vsync)

func _update_music_progress_bar(value:float): music_progress_bar.value = value

func _update_sfx_progress_bar(value:float): sfx_progress_bar.value = value

# ==================================================================================================
#                Signal listener methods
# ==================================================================================================
func _on_music_volume_changed(value:float) -> void:
	if not is_equal_approx(music_slider.value, value):
		music_slider.value = value
		_update_music_progress_bar(value)

func _on_sfx_volume_changed(value:float) -> void:
	if not is_equal_approx(sfx_slider.value, value):
		sfx_slider.value = value
		_update_sfx_progress_bar(value)

func _on_fullscreen_changed(enabled:bool) -> void:
	fullscreen_check.button_pressed = enabled

func _on_vsync_changed(enabled:bool) -> void:
	vsync_check.button_pressed = enabled
