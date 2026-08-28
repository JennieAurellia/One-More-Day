extends Node
class_name DoorManager

static var instance : DoorManager

var _doors : Array[Door] = []

# ==================================================================================================
#                Virtual methods
# ==================================================================================================
func _enter_tree() -> void: instance = self

func _exit_tree() -> void: instance = null

# ==================================================================================================
#                Door methods
# ==================================================================================================
func register_door(door: Door) -> void:
	if not _doors.has(door): _doors.append(door)

func unregister_door(door: Door) -> void:
	_doors.erase(door)

## Returns an ordered list of doors to walk through to get from from_room to to_room.
## Empty array if same room, or no path exists.
func find_door_path(from_room:EnumUtility.RoomName, to_room:EnumUtility.RoomName) -> Array[Door]:
	# Check if from and to room is the same
	if from_room == to_room: return []
	# Setup variables
	var visited : Dictionary[EnumUtility.RoomName, bool] = {from_room: true}
	var queue : Array[EnumUtility.RoomName] = [from_room]
	var came_from_door : Dictionary[EnumUtility.RoomName, Door] = {}
	var came_from_room : Dictionary[EnumUtility.RoomName, EnumUtility.RoomName] = {}
	# Loop all queue
	while not queue.is_empty():
		var room : EnumUtility.RoomName = queue.pop_front()
		if room == to_room: break
		for door:Door in _doors:
			var neighbor : EnumUtility.RoomName
			if door.push_side_room == room: neighbor = door.pull_side_room
			elif door.pull_side_room == room: neighbor = door.push_side_room
			else: continue
			if visited.has(neighbor): continue
			visited[neighbor] = true
			came_from_door[neighbor] = door
			came_from_room[neighbor] = room
			queue.append(neighbor)
	# Check if room has path
	if not visited.has(to_room): return []
	# Create and return path to room
	var path_array : Array[Door] = []
	var path_room : EnumUtility.RoomName = to_room
	while path_room != from_room:
		var door : Door = came_from_door[path_room]
		path_array.push_front(door)
		path_room = came_from_room[path_room]
	return path_array
