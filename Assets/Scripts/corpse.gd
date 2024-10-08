class_name Corpse
extends Sprite2D

@export var small_bones: Texture2D
@export var large_bones: Texture2D

var decay

func _ready() -> void:
	decay = 0
	
func _process(delta: float) -> void:
	decay += delta
	if decay > 40:
		queue_free()
		GlobalManager.update_populations()

func set_bones(small_sized: bool = false):
	if small_sized:
		texture = small_bones
	else:
		texture = large_bones
