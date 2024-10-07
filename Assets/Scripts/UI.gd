extends CanvasLayer

@export var gridcontainer: GridContainer
@export var tilemap: TileMapLayer

var show_animal_info: bool = false
var selected_name: String
var selected_description: String
var selected_animal_parent: Node

func _ready() -> void:
	pass

func _process(delta):
	if(show_animal_info && $Description.visible):
		$Description/MarginContainer/VBoxContainer/TileName.text = selected_name
		$Description/MarginContainer/HBoxContainer/TileDescription.text = selected_description
		$Description/MarginContainer/VBoxContainer/Cost.text = "Cost: " + str(AnimalDefinition.cost_from_name(selected_name, selected_animal_parent.get_child_count()))
		$Description/MarginContainer/VBoxContainer/Population.text = "Population: " + str(selected_animal_parent.get_child_count())
		
	elif(!show_animal_info && $Description.visible):
		$Description/MarginContainer/VBoxContainer/TileName.text = selected_name
		$Description/MarginContainer/HBoxContainer/TileDescription.text = selected_description
		$Description/MarginContainer/VBoxContainer/Cost.text = "Cost: " + str(TileDefinition.cost_from_name(selected_name))
		$Description/MarginContainer/VBoxContainer/Population.text = ""
		

func _on_tile_map_layer_tile_selected() -> void:
	pass # Replace with function body.

func _on_ui_tile_selected(tilename: String, tile_id: int, description: String) -> void:
	tilemap.select_tile(tile_id)
	$Description/MarginContainer/VBoxContainer/TileName.text = tilename
	$Description/MarginContainer/HBoxContainer/TileDescription.text = description
	$Description/MarginContainer/VBoxContainer/Population.text = ""
	$Description.visible = true
	selected_name = tilename
	selected_description = description
	show_animal_info = false

func _on_animal_selected(animal_name: String, animal_resource: PackedScene, descriptor: String, animal_parent: Node) -> void:
	tilemap.select_animal(animal_name, animal_resource, animal_parent)
	$Description/MarginContainer/VBoxContainer/TileName.text = animal_name
	$Description/MarginContainer/HBoxContainer/TileDescription.text = descriptor
	$Description/MarginContainer/VBoxContainer/Cost.text = "Cost: " + str(AnimalDefinition.cost_from_name(animal_name, animal_parent.get_child_count()))
	$Description/MarginContainer/VBoxContainer/Population.text = "Population: " + str(animal_parent.get_child_count())
	$Description.visible = true
	selected_name = animal_name
	selected_description = descriptor
	selected_animal_parent = animal_parent
	show_animal_info = true


func _on_tile_map_layer_tile_placed() -> void:
	$Description.visible = false
