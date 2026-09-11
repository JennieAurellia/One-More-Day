extends Node

signal game_saved
signal game_loaded
signal save_deleted

const SAVE_PATH : String = "user://game.save"
const CURRENT_VERSION : int = 1

# The data currently held in memory. Populate this with whatever your game
# needs to remember, then call save_game() to write it to disk.
var data: Dictionary = {
	"version":CURRENT_VERSION,
	"has_ended_game":false,
}

## Write `data` to disk.
func save_game() -> bool:
	var payload : Dictionary = data.duplicate(true)
	payload["_timestamp"] = Time.get_unix_time_from_system()
	var json_string := JSON.stringify(payload, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: failed to open save file for writing: %s" % error_string(FileAccess.get_open_error()))
		return false
	file.store_string(json_string)
	file.close()
	game_saved.emit()
	print("SaveManager: game saved")
	return true

## Load the save file from disk into `data`. Returns true on success.
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		push_warning("SaveManager: no save file found")
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: failed to open save file for reading: %s" % error_string(FileAccess.get_open_error()))
		return false
	var text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		push_error("SaveManager: save file is corrupted")
		return false
	data = _migrate(parsed)
	game_loaded.emit()
	print("SaveManager: game loaded")
	return true

## Handles upgrading older save formats. Extend this as your save format evolves.
func _migrate(loaded:Dictionary) -> Dictionary:
	var version : int = loaded.get("version", 0)
	if version < CURRENT_VERSION:
		# Example: if version == 0: loaded["flags"] = {}
		loaded["version"] = CURRENT_VERSION
	return loaded

## Returns true if a save file exists.
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

## Deletes the save file.
func delete_save() -> bool:
	if has_save():
		var err := DirAccess.remove_absolute(SAVE_PATH)
		if err == OK:
			save_deleted.emit()
			return true
		push_error("SaveManager: failed to delete save: %s" % error_string(err))
		return false
	return false

## Convenience helpers for reading/writing nested values without
## touching `data` directly everywhere in your code.
func set_value(key:String, value:Variant) -> void:
	data[key] = value

func get_value(key:String, default=null):
	return data.get(key, default)
