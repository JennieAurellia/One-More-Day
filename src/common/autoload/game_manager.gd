extends Node

const GAME_SCENE_PATH : String = "res://src/scene/game_scene.tscn"

var loop_count : int = 0

func initialize_game():
	loop_count = 0

func restart_day():
	loop_count += 1
	call_deferred("_do_restart_day")

func _do_restart_day(): get_tree().change_scene_to_file(GAME_SCENE_PATH)
