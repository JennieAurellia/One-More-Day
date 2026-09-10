extends RefCounted
class_name SettingsModel

const SAVE_PATH : String = "user://settings.cfg"

# Audio Settings
var music_volume : float = 1.0
var sfx_volume : float = 1.0
# Display Settings
var fullscreen : bool = false
var vsync : bool = true

func save() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("display", "vsync", vsync)
	config.save(SAVE_PATH)

func load_from_disk() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		music_volume = config.get_value("audio", "music_volume", 1.0)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		fullscreen = config.get_value("display", "fullscreen", false)
		vsync = config.get_value("display", "vsync", true)
