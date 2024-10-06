class_name Fox
extends Animal

@onready var sprite2d = $FoxAnimation
@onready var timer = $Timer
var is_waiting = false
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_list = [STATE.SEEK_WATER, STATE.WAIT, STATE.SEEK_FOOD, STATE.WAIT, STATE.RANDOM_WANDERING, STATE.PATROL]
	movement_mode = Movement.WALKING
	state_timers = [10, 10, 5, 10, 10, 4]
	timed_states = [STATE.SEEK_WATER, STATE.SEEK_FOOD]
	animal_name = "Fox"
	speed = 70
	cost = 5
	cost_scaling = 1.1
	dna_value = 20
	initial_state = STATE.SEEK_FOOD
	food_class = "Squirrel"
	
	sprite2d.play("Run")

func _change_state_if_time_elapsed(state: STATE, time_to_wait: float) -> bool:

	if time_to_wait <= time_in_state:
		current_state = state;
		# TODO: death?
		sprite2d.queue_free()
		_process(time_in_state - time_to_wait);
		return true
	return false
	

func _process(delta: float) -> void:
	super(delta)
	updateAnimation()
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			var target = tilemap.get_nearest_creature(position, Squirrel)
			if (target != null):
				destination = target.position
			else:
				return
			if move_towards_destination(delta):
				target.kill()
				advance_state()
		STATE.WAIT:
			if (time_in_state >= 3):
				advance_state()
		STATE.RANDOM_WANDERING:
			if time_in_state >= 6:
				advance_state()
			else:
				if (count > 50):
					destination = tilemap.get_nearest_tile_absolute(position, randi() % 4)
					count = 0
				move_towards_destination(delta)
				count += 1
		STATE.PATROL:
			if (time_in_state > 4):
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
		
func updateAnimation():
	match current_state:
		STATE.SEEK_WATER, STATE.SEEK_FOOD:
			sprite2d.play("Run")
		STATE.WAIT:
			sprite2d.play("Eat")
		STATE.RANDOM_WANDERING:
			sprite2d.play("Run")
		STATE.PATROL:
			sprite2d.play("Sleep")

func create_currency() -> void:
	pass
	
	
func deal_damage(body) -> void:
	pass

func _on_wait_timeout() -> void:
	is_waiting = false
	print("Wait state finished!")
