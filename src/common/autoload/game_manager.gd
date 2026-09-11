extends Node

const GAME_SCENE_PATH : String = "res://src/scene/game_scene.tscn"
const MAIN_MENU_SCENE_PATH : String = "res://src/scene/main_menu_scene.tscn"
const TIME_RESET_SFX_NAME : String = "time_reset"
const FIRST_LOOP_CUTSCENE_NAME : String = "first_loop"
const ENDING_CUTSCENE_NAME : String = "ending"

var loop_count : int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func initialize_game():
	loop_count = 0

func restart_day():
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	loop_count += 1
	if loop_count <= 1: call_deferred("_do_first_loop_cutscene")
	else: call_deferred("_do_restart_day")

func end_game():
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	_do_ending_cutscene()

func _do_restart_day():
	TransitionManager.crossfade_and_reload_scene()
	AudioManager.play_sfx(TIME_RESET_SFX_NAME)

func _do_first_loop_cutscene():
	CutsceneUI.instance.play_cutscene(FIRST_LOOP_CUTSCENE_NAME)
	await CutsceneUI.instance.cutscene_finished
	call_deferred("_do_restart_day")

func _do_ending_cutscene():
	CutsceneUI.instance.play_cutscene(ENDING_CUTSCENE_NAME)
	await CutsceneUI.instance.cutscene_finished
	SceneManager.change_scene(MAIN_MENU_SCENE_PATH)
