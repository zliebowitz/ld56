class_name Hawk
extends Animal

#func _ready() -> void:
	#current_state = initial_state

func _process(delta: float) -> void:
	super(delta)
	match current_state:
		STATE.SEEK_FOOD:
			#TODO Get nearest animal
			destination = tilemap.get_nearest_creature(position, Squirrel)
			if move_towards_destination(delta):
				advance_state()
		STATE.GO_HOME:
			destination = tilemap.get_nearest_tile_absolute(position, 3)
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT_EAT:
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
