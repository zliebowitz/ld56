class_name Squirrel
extends Animal

func _ready() -> void:
	state_list = [STATE.SEEK_WATER, STATE.WAIT_DRINKING, STATE.SEEK_FOOD, STATE.WAIT_EAT, STATE.RANDOM_WANDERING]
	movement_mode = Movement.WALKING
	state_timers = [10, 3, 10, 3, 10]
	timed_states = [STATE.SEEK_WATER, STATE.SEEK_FOOD]
	animal_name = "Squirrel"
	speed = 50
	cost = 1
	cost_scaling = 1.1
	dna_value = 10
	initial_state = STATE.SEEK_WATER
	food_class = "Nut"
	

func _change_state_if_time_elapsed(state: STATE, time_to_wait: float) -> bool:
	if time_to_wait <= time_in_state:
		current_state = state;
		# TODO: death
		_process(time_in_state - time_to_wait);
		return true
	return false
	

func _process(delta: float) -> void:
	super(delta)
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			destination = tilemap.get_nearest_tile_absolute(position, -1, 0)
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT_DRINKING, STATE.WAIT_EAT:
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			# TODO, impliment wander code
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
		
func create_currency() -> void:
	pass
