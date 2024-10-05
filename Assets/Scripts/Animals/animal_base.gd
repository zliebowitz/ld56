class_name Animal
extends Node2D

enum Movement {WALKING, FLYING, SWIMMING}

enum STATE {SEEK_WATER, WAIT_DRINKING, SEEK_FOOD, WAIT_EAT, REPRODUCE_IF_ABLE, RANDOM_WANDERING}


signal gain_dna(dna_value: int)

# A list of states that the creature will loop through, in order.
@export var state_list = [STATE.SEEK_WATER, STATE.SEEK_FOOD, STATE.RANDOM_WANDERING]
# A list of timers, showing how long each state should last. Should be the same length as the state list
@export var state_timers = [10, 10, 10]
# A list of states that, if they reach the end of the state timer, kills the creature.
@export var timed_states = [STATE.SEEK_WATER, STATE.SEEK_FOOD]
@export var animal_name: String = "PLACEHOLDER"
@export var movement_mode: Movement = Movement.WALKING
@export var destination: Vector2 = position
@export var speed: float = 6
@export var starvation_time: float = 30
@export var cost: int = 1
@export var cost_scaling: float = 1.1
@export var dna_value: int = 5
@export var initial_state: STATE = STATE.SEEK_WATER
# yuck, yuck, yuck, but I cna't find another way to do this
@export var food_class : String
@export var reproduction_site_class : String

@onready var tilemap = GlobalManager.tilemap
var current_state : STATE = initial_state
var time_in_state : float = 0


func _change_state_if_time_elapsed(state: STATE, time_to_wait: float) -> bool:
	if time_to_wait <= time_in_state:
		current_state = state;
		# TODO: death
		_process(time_in_state - time_to_wait);
		return true
	return false
	

func get_next_state() -> STATE:
	var next_state_index = get_state_list_index() + 1
	if next_state_index >= state_list.size():
		next_state_index = 0
	return state_list[next_state_index]


func advance_state() -> void:
	current_state = get_next_state();
	time_in_state = 0


func get_state_list_index() -> int:
	return state_list.find(current_state)
	

func has_time_passed() -> bool:
	return time_in_state >= state_timers[get_state_list_index()]


func kill_if_time_elapsed() -> bool:
	if has_time_passed() && timed_states.has(current_state) :
		kill()
		return true
	return false
	

func _process(delta: float) -> void:
	time_in_state += delta;
	kill_if_time_elapsed()
	
'''
	if current_state == STATE.SEEK_WATER:
		# TODO: need method to find water tiles
		_change_state_if_time_elapsed(STATE.SEEK_FOOD, 10);
	elif current_state == STATE.SEEK_FOOD:
		# TODO: need method to find food
		# there is amethod Node.is_class() that can be used with food_class
		_change_state_if_time_elapsed(STATE.REPRODUCE_IF_ABLE, 10);
	elif current_state == STATE.REPRODUCE_IF_ABLE:
		# TODO: need method to find reproduction locations
		# there is amethod Node.is_class() that can be used with reproduction_site_class
		var found_site = false;
		if not found_site:
			_change_state_if_time_elapsed(STATE.RANDOM_WANDERING, 0)
	elif current_state == STATE.RANDOM_WANDERING:
		#TODO take advantage of movement_mode here and move.
		_change_state_if_time_elapsed(STATE.SEEK_WATER, 60);
'''


func move_towards_destination(delta: float) -> bool:
	if position.distance_to(destination) <= 8:
		return true
	position += (position.direction_to(destination)).normalized() * speed * delta
	return position.distance_to(destination) <= 8


func create_dna() -> void:
	emit_signal("gain_dna", dna_value)


func kill() -> void:
	# TODO
	create_dna()
