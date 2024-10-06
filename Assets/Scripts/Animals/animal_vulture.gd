class_name Vulture
extends Animal

var hunting_grounds: Vector2 = Vector2(-1, -1)

func _ready() -> void:
	super()
	hunting_grounds = position
	

func _process_action(delta: float) -> void:
	match current_state:
		STATE.SEEK_FOOD:
			target = get_nearest_corpse()
			if is_instance_valid(target):
				destination = target.position
			else:
				var seconds_passed = Engine.get_process_frames()/60.0
				destination = hunting_grounds + Vector2.ONE.rotated(2*PI*(seconds_passed/6)) * 50
			if move_towards_destination(delta):
				if not is_instance_valid(target):
					return
				target.queue_free()
				hunting_grounds = position
				create_dna()
				advance_state()
		STATE.SEEK_ITEM:
			var nearest_tree_tile = tilemap.get_nearest_tile(position - Vector2.UP * 25, 3)
			destination = tilemap.get_tile_center(nearest_tree_tile) + Vector2.UP * 25
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		STATE.PATROL:
			var seconds_passed = Engine.get_process_frames()/60.0
			destination = hunting_grounds + Vector2.ONE.rotated(2*PI*(seconds_passed/6)) * 50
			move_towards_destination(delta)
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
