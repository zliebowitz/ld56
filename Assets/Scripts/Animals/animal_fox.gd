class_name Fox
extends Animal

@onready var animation = $FoxAnimation
var count = 0

func _process_action(delta: float) -> void:
	if animation.animation == "Sleep" && animation.is_playing():
		if time_in_state < 3:
			return
	
	updateAnimation()
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			target = get_nearest_creature_list([Squirrel, Rabbit])
			var nut_position = tilemap.get_nearest_tile_absolute(position, -1, 0)
			var nut_valid: bool = nut_position.x !=-999 and nut_position.y != -999

			
			if is_instance_valid(target) || nut_valid:
				if !nut_valid:
					destination = target.position
				elif !is_instance_valid(target):
					destination = nut_position
				else:
					if (position - nut_position).length() < (position - target.position).length():
						destination = nut_position
						nut_valid = false
					else:
						destination = target.position
						target = null
			else:
				# Try to find food.
				if (destination == Vector2(-1,-1) or (position - destination).length() < 10):
					var next_position = Vector2(position.x + randf_range(-100, 100), position.y + randf_range(-50, 50))
					destination = next_position
			if move_towards_destination(delta):
				if not is_instance_valid(target) and not nut_valid:
					return
				animation.play("Eat")
				if nut_valid:
					var coords = tilemap.get_coord_from_position(destination)
					tilemap.clear_sprite(coords)
				else:
					target.kill()
				create_dna()
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			if has_time_passed():
				advance_state()
			else:
				if (fmod(time_in_state, 2.0) < 0.01):
					var next_position =  Vector2(position.x + randf_range(-50, 50), position.y + randf_range(-50, 50))
					var coordinate = tilemap.get_coord_from_position(next_position)
					if (tilemap.is_in_bounds(coordinate) and tilemap.get_tile_info(coordinate)[0] != 2):
						destination = next_position
				if (move_towards_destination(delta)):
					animation.play("Default")
		STATE.PATROL:
			if (time_in_state > 4):
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
		
func updateAnimation():
	match current_state:
		STATE.SEEK_WATER, STATE.SEEK_FOOD:
			animation.play("Run")
		STATE.WAIT:
			animation.play("Eat")
		STATE.RANDOM_WANDERING:
			animation.play("Run")
		STATE.PATROL:
			animation.play("Sleep")
