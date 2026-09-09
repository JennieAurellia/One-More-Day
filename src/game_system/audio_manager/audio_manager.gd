extends Node

## Handles the game audio

var current_music_name : String = ""

# Node references
@onready var _music_nodes : Node = $"MusicNodes"
@onready var _sfx_nodes : Node2D = $"SFXNodes"
@onready var _sound_nodes : Node2D = $"SoundNodes"
# Music variables
var _music_list : Dictionary[String, MusicNode] = {}
var _current_music : AudioStreamPlayer
# SFX variables
var _sfx_list : Dictionary[String, SFXNode] = {}
# Sound variables
var _sound_list : Dictionary[String, SoundNode] = {}

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _ready():
	# Map all nodes
	for node:Node in _music_nodes.get_children():
		if node is not MusicNode: continue
		var music_node : MusicNode = node as MusicNode
		assert(
			!_music_list.has(music_node.key_name.to_lower()),
			"Music of name: %s, has duplicate" % music_node.key_name
		)
		_music_list[music_node.key_name.to_lower()] = music_node
	for node:Node in _sfx_nodes.get_children():
		if node is not SFXNode: continue
		var sfx_node : SFXNode = node as SFXNode
		assert(
			!_sfx_list.has(sfx_node.key_name.to_lower()),
			"SFX of name: %s, has duplicate" % sfx_node.key_name
		)
		_sfx_list[sfx_node.key_name.to_lower()] = sfx_node
	for node:Node in _sound_nodes.get_children():
		if node is not SoundNode: continue
		var sound_node : SoundNode = node as SoundNode
		assert(
			!_sound_list.has(sound_node.key_name.to_lower()),
			"Sound of name: %s, has duplicate" % sound_node.key_name
		)
		_sound_list[sound_node.key_name.to_lower()] = sound_node

# ==================================================================================================
#                Public methods
# ==================================================================================================
## Play a music node
func play_music(music_name:String):
	# Check if music exist
	assert(
		_music_list.has(music_name.to_lower()),
		"Music of name: %s, does not exist" % music_name
	)
	# Stop current music
	stop_music()
	# Play music
	_current_music = _music_list[music_name.to_lower()]
	_current_music.play()

## Stop the current music node
func stop_music():
	current_music_name = ""
	if _current_music: _current_music.stop()

## Create a SFX duplicate for the SFX node
func play_sfx(sfx_name:String, sfx_position:Vector2=Vector2.ZERO):
	# Check if SFX exist
	assert(_sfx_list.has(sfx_name.to_lower()), "SFX of name: %s, does not exist" % sfx_name)
	# Get and set SFX
	var sfx_node : SFXNode = _sfx_list[sfx_name.to_lower()]
	var sfx_node_duplicate : AudioStreamPlayer2D = sfx_node.create_sfx_duplicate()
	sfx_node_duplicate.global_position = sfx_position
	# If SFX duplicate count reached max then erase oldest sound and append new SFX duplicate
	if sfx_node.is_max_polyphony_reached():
		sfx_node.erase_sfx_duplicate(sfx_node.sfx_duplicate_list.pop_front())
	sfx_node.sfx_duplicate_list.append(sfx_node_duplicate)
	# Add SFX duplicate to scene
	sfx_node.add_child(sfx_node_duplicate)

## Clear all SFX duplicate of the SFX node that is playing
func clear_sfx(sfx_name:String):
	# Check if SFX exist
	assert(_sfx_list.has(sfx_name.to_lower()), "SFX of name: %s, does not exist" % sfx_name)
	# Find and erase all matching SFX
	var sfx_node : SFXNode = _sfx_list[sfx_name.to_lower()]
	for sfx_duplicate:AudioStreamPlayer2D in sfx_node.sfx_duplicate_list:
		sfx_node.erase_sfx_instance(sfx_duplicate)

## Clear all SFX duplicate from all SFX node
func clear_all_sfx():
	for sfx_node:SFXNode in _sfx_list.values():
		for sfx_duplicate:AudioStreamPlayer2D in sfx_node.get_children():
			sfx_node.erase_sfx_duplicate(sfx_duplicate)

## Play a sound node
func play_sound(sound_name:String, sound_position:Vector2=Vector2.ZERO, reset_sound:bool=false):
	# Check if sound exist
	assert(
		_sound_list.has(sound_name.to_lower()),
		"Sound of name: %s, does not exist" % sound_name
	)
	# Play / reset sound
	var sound_node : SoundNode = _sound_list[sound_name.to_lower()]
	if reset_sound or !sound_node.playing: sound_node.play()

## Stop a specific sound node
func stop_sound(sound_name:String):
	# Check if sound exist
	assert(
		_sound_list.has(sound_name.to_lower()),
		"Sound of name: %s, does not exist" % sound_name
	)
	# Stop sound
	var sound_node : SoundNode = _sound_list[sound_name.to_lower()]
	sound_node.stop()

## Stop all sound node
func stop_all_sound():
	for sound_node:SoundNode in _sound_list.values():
		sound_node.stop()
