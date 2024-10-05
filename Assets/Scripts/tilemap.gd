class_name WorldMapLayer
extends TileMapLayer

@export var tile_size: Vector2
@export var map_size: Vector2

@onready var spritelayer: TileMapLayer = $SpriteLayer

var id_map: Array[int]
var sprite_id_map: Array[int]

var is_placing_tile := false
var selected_tile_id := -1

signal tile_placed

func _ready() -> void:
	for y in map_size.y:
		for x in map_size.x:
			var coords = Vector2i(x,y)
			id_map.append(get_cell_source_id(coords))
			sprite_id_map.append(spritelayer.get_cell_source_id(coords))

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and is_placing_tile:
		var coords = floor(get_global_mouse_position()/tile_size)
		var cell_id = get_cell_source_id(coords)
		
		#If we haven't initialized a tile there, don't place a new one
		if cell_id == -1:
			return
		place_tile(coords, selected_tile_id)
		is_placing_tile = false
		selected_tile_id = -1
		tile_placed.emit()


func select_tile(tile_id: int) -> void:
	selected_tile_id = tile_id
	is_placing_tile = true


func place_tile(coords: Vector2i, map_id: int = -1, sprite_id: int = -1):
	if map_id != -1:
		set_cell(coords, map_id, Vector2i(2, 1))
		id_map[get_array_index(coords)] = selected_tile_id
		print("Placing tile id ", selected_tile_id, " at ", coords)
		
	if sprite_id != -1:
		spritelayer.set_cell(coords, sprite_id, Vector2i(0, 0))
		sprite_id_map[get_array_index(coords)] = sprite_id
		print("Placing Sprite id ", sprite_id, " at ", coords)


#Returns [TileMapID, SpriteLayerID]
func get_tile_info(coords: Vector2i) -> Array[int]:
	var index = coords.x + coords.y * map_size.x
	return [id_map[index], sprite_id_map[index]]
	

#Returns position center of tile of given coordinate
func get_tile_center(coords: Vector2i) -> Vector2:
	var x_loc: float = coords.x * tile_size.x + tile_size.x/2
	var y_loc: float = coords.y * tile_size.y + tile_size.y/2
	return Vector2(x_loc, y_loc)


#Returns the tile that the position is on.
func get_coord_from_position(location: Vector2) -> Vector2i:
	var x_coord = floor(location.x / tile_size.x)
	var y_coord = floor(location.y / tile_size.y)
	return Vector2i(x_coord, y_coord)

func get_array_index(coords: Vector2i) -> int:
	return coords.x + coords.y * map_size.x
	
func get_adjacent_tiles(coords: Vector2i) -> Array[Vector2i]:
	var output_array: Array[Vector2i] = []
	for test_vector in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
		test_vector = test_vector + coords
		if test_vector == coords: continue
		if test_vector.y < 0 or test_vector.y >= map_size.y: continue
		if test_vector.x < 0 or test_vector.x >= map_size.x: continue
		if get_tile_info(test_vector)[0] == -1: 			continue
		output_array.append(test_vector)
	return output_array

#No pathfinding, strict nearest
func get_nearest_tile(starting_location: Vector2, id: int = -1, sprite_id: int = -1) -> Vector2i:
	if id == -1 and sprite_id == -1:
		print("You aren't searching for anything!")
		return Vector2i(-1, -1)
		
	var distance := 999999.9
	var closest := Vector2i(-1,-1)
	for y in map_size.y:
		for x in map_size.x:
			var coords = Vector2i(x, y)
			var tile_info = get_tile_info(coords)
			if (id != -1 and tile_info[0] == id) or (sprite_id != -1 and tile_info[1] == sprite_id):
				var new_distance = starting_location.distance_squared_to(get_tile_center(coords))
				if new_distance < distance:
					distance = new_distance
					closest = coords
	return closest


func get_nearest_tile_absolute(starting_location: Vector2, id: int = -1, sprite_id: int = -1) -> Vector2:
	return get_nearest_tile(starting_location, id, sprite_id)*32
