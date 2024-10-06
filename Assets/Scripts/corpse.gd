class_name Corpse
extends Sprite2D

@export var small_bones: Texture2D
@export var large_bones: Texture2D

func set_bones(small_sized: bool = false):
	if small_sized:
		texture = small_bones
	else:
		texture = large_bones
