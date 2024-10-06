class_name Squirrel
extends Animal

func _ready() -> void:
	pass
	#state_list = [STATE.SEEK_WATER, STATE.WAIT_DRINKING, STATE.SEEK_FOOD, STATE.WAIT_EAT, STATE.RANDOM_WANDERING]
	#movement_mode = Movement.WALKING
	#state_timers = [10, 3, 10, 3, 10]
	#timed_states = [STATE.SEEK_WATER, STATE.SEEK_FOOD]
	#animal_name = "Squirrel"
	#speed = 50
	#cost = 1
	#cost_scaling = 1.1
	#dna_value = 10
	#initial_state = STATE.SEEK_WATER
	#food_class = "Nut"
	
var wander_wait: float = 2.0

func _change_state_if_time_elapsed(state: STATE, time_to_wait: float) -> bool:
	if time_to_wait <= time_in_state:
		current_state = state;
		# TODO: death
		_process(time_in_state - time_to_wait);
		return true
	return false
	

func _process_action(delta: float) -> void:
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			destination = tilemap.get_nearest_tile_absolute(position, -1, 0)
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT:
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
			
			if move_towards_destination(delta):
				wander_wait += delta
			if has_time_passed():
				wander_wait = 0
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
