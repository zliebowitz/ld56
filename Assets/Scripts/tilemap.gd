class_name WorldMapLayer
extends TileMapLayer

@export var tile_size: Vector2
@export var map_size: Vector2

@onready var spritelayer: TileMapLayer = $SpriteLayer
@onready var grassborderlayer: TileMapLayer = $GrassBorderLayer
@onready var sandborderlayer: TileMapLayer = $SandBorderLayer
@onready var main: Main = $".."

var id_map: Array[int]
var sprite_id_map: Array[int]

var is_placing_tile := false
var selected_tile_id := -1


var is_placing_animal := false
var animal_name: String
var animal_resource: PackedScene
var animal_descriptor: String
var animal_parent: Node

var process_kneecap: float = 0.0

signal tile_placed

func _ready() -> void:
	for y in map_size.y:
		for x in map_size.x:
			var coords = Vector2i(x,y)
			id_map.append(get_cell_source_id(coords))
			sprite_id_map.append(spritelayer.get_cell_source_id(coords))
	_update_border_layers()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"): 
		var mouse_pos := get_global_mouse_position()
		var coords = floor(mouse_pos/tile_size)
		var cell_id = get_cell_source_id(coords)
		
		#If we haven't initialized a tile there, don't place a new one
		if cell_id == -1:
			return
		if is_placing_tile:
			# Determine cost of tiles and make sure have enough DNA
			var current_cost: int = TileDefinition.cost_from_id(selected_tile_id)
			if current_cost > main.dna:
				return
			# Don't place tile on same type of tile.
			if cell_id == selected_tile_id:
				return
			#place the tile
			place_tile(coords, selected_tile_id)
			is_placing_tile = false
			selected_tile_id = -1
			tile_placed.emit()
			main._on_gain_dna(-current_cost)
			TileDefinition.tile_placed_count += 1
		elif is_placing_animal:
			var animal: Animal = animal_resource.instantiate()
			var current_cost: int = AnimalDefinition.cost_from_name(animal_name, animal_parent.get_child_count())
			if current_cost > main.dna:
				animal.free()
				return
			if animal.movement_mode == Animal.Movement.WALKING and cell_id == TileDefinition.TILE_WATER: # water
				animal.free()
				return
			if animal.movement_mode == Animal.Movement.SWIMMING and cell_id != TileDefinition.TILE_WATER: # water
				animal.free()
				return
			animal.position = mouse_pos
			animal_parent.add_child(animal)
			main._on_gain_dna(-current_cost)
			

func _process(delta: float) -> void:
	process_kneecap += delta
	if process_kneecap > 0.2:
		process_kneecap = 0


func select_tile(tile_id: int) -> void:
	selected_tile_id = tile_id
	is_placing_tile = true
	is_placing_animal = false
	
	
func select_animal(animal_name: String, resource: PackedScene, parent: Node) -> void:
	self.animal_resource = resource
	self.animal_parent = parent
	self.animal_name = animal_name
	self.is_placing_tile = false
	self.is_placing_animal = true



func place_tile(coords: Vector2i, map_id: int = -1, sprite_id: int = -1):
	if map_id != -1:
		var scene_source = tile_set.get_source(map_id)
		if scene_source is TileSetScenesCollectionSource:
			set_cell(coords, map_id, Vector2i(0, 0), 1)
		else:
			set_cell(coords, map_id, Vector2i(2, 1))
		id_map[get_array_index(coords)] = map_id
		
	if sprite_id != -1:
		var scene_source = tile_set.get_source(sprite_id)
		if scene_source is TileSetScenesCollectionSource:
			spritelayer.set_cell(coords, sprite_id, Vector2i(0, 0), 1)
		else:
			spritelayer.set_cell(coords, sprite_id, Vector2i(0, 0))
		sprite_id_map[get_array_index(coords)] = sprite_id
	_update_border_layers()

func clear_sprite(coords: Vector2i):
	sprite_id_map[get_array_index(coords)] = -1
	spritelayer.erase_cell(coords)

#Returns [TileMapID, SpriteLayerID]
func get_tile_info(coords: Vector2i) -> Array[int]:
	var index = coords.x + coords.y * map_size.x
	return [id_map[index], sprite_id_map[index]]
	

#Returns position center of tile of given coordinate
func get_tile_center(coords: Vector2i) -> Vector2:
	var x_loc: float = coords.x * tile_size.x + tile_size.x/2
	var y_loc: float = coords.y * tile_size.y + tile_size.y/2
	return Vector2(x_loc, y_loc)

func is_in_bounds(coords: Vector2i) -> bool:
	var x_good = coords.x >= 0 and coords.x < map_size.x
	var y_good = coords.y >= 0 and coords.y < map_size.y
	return x_good and y_good


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
	
func get_tile_scene(coords: Vector2i) -> Node2D:
	var test_position = get_tile_center(coords)
	for child in get_children():
		if child is not Node2D and child is not TileMapLayer: return
		if child.position.distance_to(test_position) <= 8:
			return child
	return null

#No pathfinding, strict nearest
func get_nearest_tile(starting_location: Vector2, id: int = -1, sprite_id: int = -1) -> Vector2i:
	if id == -1 and sprite_id == -1:
		print("You aren't searching for anything!")
		return Vector2i(-1, -1)
	if not can_process_pathfinding():
		return Vector2i(-999, -999)
	var distance := 999999.9
	var closest := Vector2i(-1,-1)
	if id != -1:
		var map_tiles: Array[Vector2i] = get_used_cells_by_id(id)
		for tile: Vector2i in map_tiles:
			var new_distance = starting_location.distance_squared_to(get_tile_center(tile))
			if new_distance < distance:
				distance = new_distance
				closest = tile
	if sprite_id != -1:
		var sprite_tiles: Array[Vector2i] = spritelayer.get_used_cells_by_id(sprite_id)
		for tile: Vector2i in sprite_tiles:
			var new_distance = starting_location.distance_squared_to(get_tile_center(tile))
			if new_distance < distance:
				distance = new_distance
				closest = tile
	#for y in map_size.y:
		#for x in map_size.x:
			#var coords = Vector2i(x, y)
			#var tile_info = get_tile_info(coords)
			#if (id != -1 and tile_info[0] == id) or (sprite_id != -1 and tile_info[1] == sprite_id):
				#var new_distance = starting_location.distance_squared_to(get_tile_center(coords))
				#if new_distance < distance:
					#distance = new_distance
					#closest = coords
	return closest


func get_nearest_tile_absolute(starting_location: Vector2, id: int = -1, sprite_id: int = -1) -> Vector2:
	var tile: Vector2i = get_nearest_tile(starting_location, id, sprite_id)
	if tile == Vector2i(-999, -999): return tile
	var center = get_tile_center(tile)
	if center.x < 0 or center.y < 0: return Vector2(-1, -1)
	var offset = center + (starting_location - center).normalized()*12
	return offset

func can_process_pathfinding() -> bool:
	return process_kneecap > 0.1

#func get_nearest_creature(starting_location: Vector2, creature_type: Variant) -> Animal:
	#var distance := 999999.9
	#var closest: Animal = null
	#var main = get_parent()
	#for animal in get_tree().get_nodes_in_group("animal"):
		#if is_instance_of(animal, creature_type):
			#var new_distance = starting_location.distance_squared_to(animal.position)
			#if new_distance < distance:
				#distance = new_distance
				#closest = animal
	#return closest


func _update_border_layers():
	_update_border_layer(0)
	_update_border_layer(1)



# VERY IPORTANT!!!
# VERY IPORTANT!!!
# VERY IPORTANT!!!
# VERY IPORTANT!!!
#
# Pretend this function doesn't exist
#
# I am sorry you have to lay eyes on such a gross function.
# Please ignore it, pretend it doesn't exist.
# If something breaks, continue ignoring it, and compain in Travis' direction.
func _update_border_layer(borderlayerindex):
	var borderlayer:TileMapLayer
	match borderlayerindex:
		0:
			borderlayer = grassborderlayer
		1: 
			borderlayer = sandborderlayer
	for y in range(1, map_size.y-1):
		for x in range(1, map_size.x-1):
			var coords = Vector2i(x, y)
			borderlayer.erase_cell(coords)
			var center_tile_info = get_tile_info(Vector2i(x, y))[0]
			# tiles are placed in reading order:
			# 0 1 2
			# 3 X 4
			# 5 6 7
			var surrounding_info:Array[int] = []
			surrounding_info.append(get_tile_info(Vector2i(x-1, y-1))[0])
			surrounding_info.append(get_tile_info(Vector2i(x, y-1))[0])
			surrounding_info.append(get_tile_info(Vector2i(x+1, y-1))[0])
			surrounding_info.append(get_tile_info(Vector2i(x-1, y))[0])
			# Ignore the center tile. 
			#surrounding_info.append(get_tile_info(Vector2i(x, y))[0])
			surrounding_info.append(get_tile_info(Vector2i(x+1, y))[0])
			surrounding_info.append(get_tile_info(Vector2i(x-1, y+1))[0])
			surrounding_info.append(get_tile_info(Vector2i(x, y+1))[0])
			surrounding_info.append(get_tile_info(Vector2i(x+1, y+1))[0])
			
			
			# Treat tree tiles as grass.
			for i in surrounding_info.size():
				if surrounding_info[i] == 3:
					surrounding_info[i] = 0
			
			# Determine which overlay to do.
			var dominant_border = borderlayerindex
			if center_tile_info == borderlayerindex || !surrounding_info.has(borderlayerindex):
				dominant_border = -1
			
			
			# If the tile is grass, don't do anything on it. Grass is always on top
			if center_tile_info == 0:
				dominant_border = -1
			
			
			# Format a unique string based on the surrounding dominant tiles.
			var border_string:String = ""
			var border:Array[bool] = []
			for i in surrounding_info.size():
				border.append(surrounding_info[i] == dominant_border)
					
			
			
			
			
			var tile_position
			# Full surround
			if border[1] && border[3] && border[4] && border[6]:
				tile_position = Vector2i(1,7)
			# Three sides
			elif border[1] && border[3] && border[4]:
				tile_position = Vector2i(2,8)
			elif border[1] && border[3] && border[6]:
				tile_position = Vector2i(3,8)
			elif border[1] && border[4] && border[6]:
				tile_position = Vector2i(1,8)
			elif border[3] && border[4] && border[6]:
				tile_position = Vector2i(4,8)
			# Two sides adjacent
			elif border[1] && border[3]:
				tile_position = Vector2i(3,7)
			elif border[4] && border[6]:
				tile_position = Vector2i(2,6)
			elif border[1] && border[4]:
				tile_position = Vector2i(2,7)
			elif border[3] && border[6]:
				tile_position = Vector2i(3,6)
			# 2 parrellel sides
			elif border[1] && border[6]:
				tile_position = Vector2i(4,7)
			elif border[3] && border[4]:
				tile_position = Vector2i(4,6)
			# Single Side
			elif border[1]:
				tile_position = Vector2i(3,5)
			elif border[3]:
				tile_position = Vector2i(4,4)
			elif border[4]:
				tile_position = Vector2i(2,4)
			elif border[6]:
				tile_position = Vector2i(3,3)
			# Double Corners
			elif border[0] && border[7]:
				tile_position = Vector2i(1,6)
			elif border[2] && border[5]:
				tile_position = Vector2i(1,5)
			elif border[0] && border[2]:
				tile_position = Vector2i(2,9)
			elif border[5] && border[7]:
				tile_position = Vector2i(1,9)
			elif border[0] && border[5]:
				tile_position = Vector2i(3,9)
			elif border[2] && border[7]:
				tile_position = Vector2i(4,9)
			# Single Corners
			elif border[0]:
				tile_position = Vector2i(4,5)
			elif border[2]:
				tile_position = Vector2i(2,5)
			elif border[5]:
				tile_position = Vector2i(4,3)
			elif border[7]:
				tile_position = Vector2i(2,3)
			else:
				tile_position = null
			
			# Set the tile!
			if tile_position != null:
				borderlayer.set_cell(coords, dominant_border, tile_position)
