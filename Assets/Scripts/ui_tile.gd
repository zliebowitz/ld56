extends TextureRect

@export var tile_name: String
@export var tile_id: int
@export_multiline var description: String

signal ui_tile_selected(tile_id: int)



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("click"):
		emit_signal("ui_tile_selected", tile_name, tile_id, description)
		accept_event()
