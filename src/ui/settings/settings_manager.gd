extends Node

signal music_volume_changed(value:float)
signal sfx_volume_changed(value:float)
signal fullscreen_changed(enabled:bool)
signal vsync_changed(enabled:bool)

var music_volume: float:
	set(value): set_music_volume(value)
	get: return _model.music_volume
var sfx_volume: float:
	set(value): set_sfx_volume(value)
	get: return _model.sfx_volume
var fullscreen: bool:
	set(value): set_fullscreen(value)
	get: return _model.fullscreen
var vsync: bool:
	set(value): set_vsync(value)
	get: return _model.vsync

var _model : SettingsModel = SettingsModel.new()
var _music_bus_index : int
var _sfx_bus_index : int

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready() -> void:
	_music_bus_index = AudioServer.get_bus_index("Music")
	_sfx_bus_index = AudioServer.get_bus_index("SFX")
	_model.load_from_disk()
	_apply_all()

# ==================================================================================================
#                Settings methods
# ==================================================================================================
func _apply_all() -> void:
	# Apply audio settings
	_apply_bus_volume(_music_bus_index, _model.music_volume)
	_apply_bus_volume(_sfx_bus_index, _model.sfx_volume)
	music_volume_changed.emit(_model.music_volume)
	sfx_volume_changed.emit(_model.sfx_volume)
	# Apply display settings
	if _model.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if _model.vsync else DisplayServer.VSYNC_DISABLED
	)
	fullscreen_changed.emit(_model.fullscreen)
	vsync_changed.emit(_model.vsync)

# ==================================================================================================
#                Audio settings methods
# ==================================================================================================
func set_music_volume(value:float) -> void:
	_model.music_volume = clamp(value, 0.0, 1.0)
	_apply_bus_volume(_music_bus_index, _model.music_volume)
	_model.save()
	music_volume_changed.emit(_model.music_volume)

func set_sfx_volume(value:float) -> void:
	_model.sfx_volume = clamp(value, 0.0, 1.0)
	_apply_bus_volume(_sfx_bus_index, _model.sfx_volume)
	_model.save()
	sfx_volume_changed.emit(_model.sfx_volume)

func _apply_bus_volume(bus_index:int, linear_value:float) -> void:
	var db := linear_to_db(linear_value) if linear_value > 0.0 else -80.0
	AudioServer.set_bus_volume_db(bus_index, db)
	AudioServer.set_bus_mute(bus_index, linear_value <= 0.0)

# ==================================================================================================
#                Display settings methods
# ==================================================================================================
func set_fullscreen(enabled: bool) -> void:
	_model.fullscreen = enabled
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	_model.save()
	fullscreen_changed.emit(enabled)

func set_vsync(enabled: bool) -> void:
	_model.vsync = enabled
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED
	)
	_model.save()
	vsync_changed.emit(enabled)
