class_name Squirrel
extends Animal
	
var wander_wait: float = 2.0


func _process_action(delta: float) -> void:
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			$AnimatedSprite2D.animation = "run"
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			destination = tilemap.get_nearest_tile_absolute(position, -1, 0)
			$AnimatedSprite2D.animation = "run"
			if move_towards_destination(delta):
				create_dna()
				if randf() < 0.75:		#75% chance to eat the nuts
					var coords = tilemap.get_coord_from_position(destination)
					tilemap.clear_sprite(coords)
				advance_state()
		STATE.WAIT:
			$AnimatedSprite2D.animation = "idle"
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			if wander_wait > 1.0:
				var new_destination = Vector2(position.x + randf_range(-100, 100), position.y + randf_range(-100, 100))
				#If a valid tile
				var coord = tilemap.get_coord_from_position(new_destination)
				if tilemap.is_in_bounds(coord) and tilemap.get_tile_info(coord)[0] >= 0:
					destination = new_destination
				else: destination = position
				wander_wait = 0.0
				
			if position.distance_to(destination) <= 8:
				$AnimatedSprite2D.animation = "idle"
			else:
				$AnimatedSprite2D.animation = "run"
			
			if move_towards_destination(delta):
				wander_wait += delta
			if has_time_passed():
				wander_wait = 0
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
	# Flip sprite if the squirrel is facing the opposite direction
	var direction = position.angle_to_point(destination)
	if direction < 0:
		direction += 2*PI
	$AnimatedSprite2D.set_flip_h(direction > PI/2 && direction < 3*PI/2 )
