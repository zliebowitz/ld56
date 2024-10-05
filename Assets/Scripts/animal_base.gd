class_name Animal
extends AnimatedSprite2D

enum Movement {WALKING, FLYING, SWIMMING}

enum STATE {SEEK_WATER, SEEK_FOOD, REPRODUCE_IF_ABLE, RANDOM_WANDERING}

@export var animal_name: String = "PLACEHOLDER"
@export var movement_mode: Movement = Movement.WALKING
@export var speed: float = 6
@export var starvation_time: float = 30
@export var cost: int = 1
@export var cost_scaling: float = 1.1
@export var initial_state: STATE = STATE.SEEK_WATER
# yuck, yuck, yuck, but I cna't find another way to do this
@export var food_class : String
@export var reproduction_site_class : String


var current_state : STATE = initial_state
var time_in_state : float = 0


func _change_state_if_time_elapsed(state: STATE, time_to_wait: float) -> bool:
	if time_to_wait <= time_in_state:
		current_state = state;
		# TODO: death
		_process(time_in_state - time_to_wait);
		return true
	return false
	

func _process(delta: float) -> void:
	time_in_state += delta;
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
		
func create_currency() -> void:
	pass
