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
