extends Node

const GAME_SCENE_PATH : String = "res://src/scene/game_scene.tscn"
const MAIN_MENU_SCENE_PATH : String = "res://src/scene/main_menu_scene.tscn"
const TIME_RESET_SFX_NAME : String = "time_reset"

var loop_count : int = 0

func initialize_game():
	loop_count = 0

func restart_day():
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	loop_count += 1
	call_deferred("_do_restart_day")

func end_game():
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	SceneManager.change_scene(MAIN_MENU_SCENE_PATH)

func _do_restart_day():
	TransitionManager.crossfade_and_reload_scene()
	AudioManager.play_sfx(TIME_RESET_SFX_NAME)
