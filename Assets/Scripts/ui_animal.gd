extends TextureRect

@export var animal_name: String
@export var animal_resource: PackedScene
@export_multiline var description: String
@export var animal_parent: Node

signal ui_animal_selected(animal_name: String, animal_resource: PackedScene, descriptor: String, animal_parent: Node)



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("click"):
		ui_animal_selected.emit(animal_name, animal_resource, description, animal_parent)
		accept_event()
