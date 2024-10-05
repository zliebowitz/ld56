extends CanvasLayer

@export var gridcontainer: GridContainer
@export var tilemap: TileMapLayer

func _ready() -> void:
	pass

func _on_tile_map_layer_tile_selected() -> void:
	pass # Replace with function body.


func _on_ui_tile_selected(tilename: String, tile_id: int, description: String) -> void:
	tilemap.select_tile(tile_id)
	$Description/TileName.text = tilename
	$Description/TileDescription.text = description
	$Description.visible = true


func _on_tile_map_layer_tile_placed() -> void:
	$Description.visible = false
