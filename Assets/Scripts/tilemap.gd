extends TileMapLayer

@export var tile_size: Vector2

var is_placing_tile := false
var selected_tile_id := -1

signal tile_placed

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and is_placing_tile:
		var coords = floor(get_global_mouse_position()/tile_size)
		var cell_id = get_cell_source_id(coords)
		
		#If we haven't initialized a tile there, don't place a new one
		if cell_id == -1:
			return
		set_cell(coords, selected_tile_id, Vector2i(0,0))
		print("Placing tile id ", selected_tile_id, " at ", coords)
		is_placing_tile = false
		selected_tile_id = -1
		tile_placed.emit()


func select_tile(tile_id: int) -> void:
	selected_tile_id = tile_id
	is_placing_tile = true
