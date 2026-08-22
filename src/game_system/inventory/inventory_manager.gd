extends Node

signal item_added(item_data:ItemData)
signal item_removed(item_data:ItemData)
signal selection_changed(item_data:ItemData)

var items : Array[ItemData] = []
var selected_item : ItemData = null

func add_item(item_data:ItemData):
	if item_data == null: return
	items.append(item_data)
	item_added.emit(item_data)

func remove_item(item_data: ItemData):
	if not items.has(item_data): return
	items.erase(item_data)
	if selected_item == item_data:
		select_item(null)
	item_removed.emit(item_data)

func has_item(id:StringName):
	return items.any(func(i): return i.id == id)

func select_item(item_data: ItemData):
	# Toggle off if clicking the already-selected item
	selected_item = null if selected_item == item_data else item_data
	selection_changed.emit(selected_item)

func consume_selected():
	if selected_item:
		remove_item(selected_item)
