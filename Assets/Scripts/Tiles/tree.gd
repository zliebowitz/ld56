class_name Tree_Tile
extends Sprite2D

@onready var tilemap: WorldMapLayer = GlobalManager.tilemap
@onready var timer = $Timer

@export var nut_timer: float = 0.0
@export var std_deviation: float = 0.0

var adjacent_coordinates: Array[Vector2i]
var coordinate: Vector2i

func _ready() -> void:
	coordinate = tilemap.get_coord_from_position(position)
	adjacent_coordinates = tilemap.get_adjacent_tiles(coordinate)
	timer.start(randfn(nut_timer, 0.25))


func _on_timer_timeout() -> void:
	var valid_adjacents := adjacent_coordinates
	while(valid_adjacents.size() > 0):
		var test_coord: Vector2i = valid_adjacents.pick_random()
		var test_info := tilemap.get_tile_info(test_coord)
		if not test_info[0] in [2,3] and not test_info[1] in [0]:
			tilemap.place_tile(test_coord, -1, 0)
			break
		valid_adjacents.erase(test_coord)
	timer.start(randfn(nut_timer, 0.25))
