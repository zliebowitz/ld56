extends Control

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("title_animation")
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tilemap.tscn")
	pass # Replace with function body.
