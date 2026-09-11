extends Node

const GAME_SCENE_PATH : String = "res://src/scene/game_scene.tscn"
const MAIN_MENU_SCENE_PATH : String = "res://src/scene/main_menu_scene.tscn"
const LOOP_CUTSCENE_NAME : String = "loop"
const FIRST_LOOP_CUTSCENE_NAME : String = "first_loop"
const ENDING_CUTSCENE_NAME : String = "ending"
const FREEZE_FRAME_DURATION : float = 2.0

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
	if loop_count <= 1: call_deferred("_do_first_loop")
	else: call_deferred("_do_loop")

func end_game():
	# Clear all audio
	AudioManager.stop_music()
	AudioManager.clear_all_sfx()
	AudioManager.stop_all_sound()
	# Do freeze frame and quit
	TransitionManager.freeze_frame()
	await get_tree().create_timer(FREEZE_FRAME_DURATION).timeout
	SaveManager.set_value("has_ended_game", true)
	SaveManager.save_game()
	get_tree().quit()

func _do_loop():
	CutsceneUI.instance.play_cutscene(LOOP_CUTSCENE_NAME)
	await CutsceneUI.instance.cutscene_finished
	TransitionManager.crossfade_and_reload_scene()

func _do_first_loop():
	CutsceneUI.instance.play_cutscene(FIRST_LOOP_CUTSCENE_NAME)
	await CutsceneUI.instance.cutscene_finished
	TransitionManager.crossfade_and_reload_scene()

func _do_ending_cutscene():
	CutsceneUI.instance.play_cutscene(ENDING_CUTSCENE_NAME)
	await CutsceneUI.instance.cutscene_finished
	SceneManager.change_scene(MAIN_MENU_SCENE_PATH)
