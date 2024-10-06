class_name Animal
extends Node2D

enum Movement {WALKING, FLYING, SWIMMING}

enum STATE {SEEK_WATER, SEEK_FOOD, SEEK_ITEM, WAIT, REPRODUCE_IF_ABLE, RANDOM_WANDERING, PATROL}


signal gain_dna(dna_value: int)

# A list of states that the creature will loop through, in order.
@export var state_list: Array[STATE] = []
# A list of timers, showing how long each state should last. Should be the same length as the state list
@export var state_timers: Array[float] = [10, 10, 10]
# A list of states that, if they reach the end of the state timer, kills the creature.
@export var timed_states: Array[int] = []
@export var animal_name: String = "PLACEHOLDER"
@export var movement_mode: Movement = Movement.WALKING
@export var destination: Vector2 = position
@export var speed: float = 6
@export var cost: int = 1
@export var cost_scaling: float = 1.1
@export var dna_value: int = 5
@export var dna_on_feed: int = 5
@export var initial_state: STATE = STATE.SEEK_WATER
# yuck, yuck, yuck, but I cna't find another way to do this
@export var food_class : String
@export var reproduction_site_class : String

@onready var tilemap: WorldMapLayer = GlobalManager.tilemap
@onready var current_state : STATE = initial_state
var time_in_state : float = 0
var index: int = 0

func _ready() -> void:
	var main = GlobalManager.main
	add_to_group("animal")
	gain_dna.connect(main._on_gain_dna)


func _process(delta: float) -> void:
	time_in_state += delta;
	kill_if_time_elapsed()
	_process_action(delta)
	

func get_next_state() -> STATE:
	index = index + 1
	if index >= state_list.size():
		index = 0
	return state_list[index]


func advance_state() -> void:
	current_state = get_next_state();
	time_in_state = 0


func get_state_list_index() -> int:
	return index
	

func has_time_passed() -> bool:
	return time_in_state >= state_timers[get_state_list_index()]


func kill_if_time_elapsed() -> bool:
	if has_time_passed() && timed_states.has(index) :
		kill()
		return true
	return false
	
	
func _process_action(delta: float) -> void:
	pass


func move_towards_destination(delta: float) -> bool:
	if position.distance_to(destination) <= 8:
		return true
	position += (position.direction_to(destination)).normalized() * speed * delta
	return position.distance_to(destination) <= 8


func create_dna() -> void:
	emit_signal("gain_dna", dna_on_feed)


func kill() -> void:
	queue_free()


func get_nearest_creature(creature_type: Variant) -> Animal:
	if not has_node("SearchRadius"): return
	var search_radius: Area2D = $SearchRadius
	var areas := search_radius.get_overlapping_areas()
	var distance := 999999.9
	var closest: Animal = null
	for area in areas:
		var animal = area.get_parent()
		if is_instance_of(animal, creature_type):
			var new_distance = position.distance_squared_to(animal.position)
			if new_distance < distance:
				distance = new_distance
				closest = animal
	return closest
