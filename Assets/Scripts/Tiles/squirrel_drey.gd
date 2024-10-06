class_name SquirrelDrey
extends Sprite2D

var coords: Vector2i
@onready var squirrel_scene: PackedScene = preload("res://Assets/Scripts/Animals/Squirrel.tscn")

func spawn_squirrel(squirrel: Squirrel):
	var new_squirrel = squirrel_scene.instantiate()
	new_squirrel.position = position + Vector2(randi_range(-16, 16), randi_range(-16, 16))
	squirrel.add_sibling(new_squirrel)
