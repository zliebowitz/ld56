class_name Hawk
extends Animal

@onready var animation = $AnimatedSprite2D

func _process_action(delta: float) -> void:
	if animation.animation == "Eat" && animation.is_playing():
		if time_in_state < 2:
			return
		
	updateAnimation()
	match current_state:
		STATE.SEEK_FOOD:
			target = get_nearest_creature_list([Squirrel, Rabbit])
			if is_instance_valid(target):
				destination = target.position
			else: destination = position
			if move_towards_destination(delta):
				if not is_instance_valid(target):
					return
				animation.play("Eat")
				target.kill()
				create_dna()
				advance_state()
		STATE.SEEK_ITEM:
			if can_process_pathfinding():
				var nearest_tree_tile = tilemap.get_nearest_tile(position - Vector2.UP * 25, 3)
				destination = tilemap.get_tile_center(nearest_tree_tile) + Vector2.UP * 25
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")

func updateAnimation():
	match current_state:
		STATE.SEEK_FOOD, STATE.SEEK_ITEM:
			animation.play("Fly")
		STATE.WAIT:
			animation.play("Idle")
