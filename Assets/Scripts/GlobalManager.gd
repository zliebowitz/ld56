extends Node

@onready var tilemap: WorldMapLayer:
	get:
		if tilemap == null:
			tilemap = get_tree().root.get_node("Main/TileMapLayer")
		return tilemap

@onready var main: Node2D:
	get: 
		if main == null: 
			main = get_tree().root.get_node("Main")
		return main
		
var creature_count: int = 0

func add_creature_count() -> void:
	creature_count = creature_count + 1
	#print("Creature Count: ", creature_count, " Frame: ", Engine.get_frames_drawn())
