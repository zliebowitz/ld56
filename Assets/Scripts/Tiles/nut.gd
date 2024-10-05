class_name Nut_Sprite
extends Sprite2D

@onready var tilemap: WorldMapLayer = GlobalManager.tilemap
@onready var timer = $Timer

@export var nut_timer: float = 0.0
@export var std_deviation: float = 0.0

var coordinate: Vector2i

func _ready() -> void:
	coordinate = tilemap.get_coord_from_position(position)
	timer.start(25)


func _on_timer_timeout() -> void:
	var test_info := tilemap.get_tile_info(coordinate)
		# if the tile is grass, grow a tree
	if test_info[0] == 0:
		tilemap.place_tile(coordinate, 3)
	queue_free()
