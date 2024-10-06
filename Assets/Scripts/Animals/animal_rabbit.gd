class_name Rabbit
extends Animal

var rabbit_scene: PackedScene = preload("res://Assets/Scripts/Animals/Rabbit.tscn")
@onready var sprite2d = $RabbitAnimation

@export var feed_to_reproduce: int = 3
@export var ratio_to_strip_grass: float = 0.1

var eat_counter := 0
var is_waiting = false
var count = 0

func _process_action(delta: float) -> void:
	updateAnimation()
	match current_state:
		STATE.SEEK_FOOD:
			destination = tilemap.get_nearest_tile_absolute(position, 0)
			if move_towards_destination(delta):
				eat_counter = eat_counter + 1
				if randf() < ratio_to_strip_grass:
					var destination_tile = tilemap.get_coord_from_position(destination)
					#If the tile isn't still grass, don't do anything
					if not tilemap.get_tile_info(destination_tile)[0] == 0: return
					tilemap.place_tile(destination_tile, 1)
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			if has_time_passed():
				advance_state()
			else:
				if (count > 50):
					var offset = Vector2(randi_range(-16, 16), randi_range(-16, 16))
					destination = tilemap.get_nearest_tile_absolute(position, randi() % 4) + offset
					count = 0
				move_towards_destination(delta)
				count += 1
		STATE.REPRODUCE_IF_ABLE:
			if eat_counter < feed_to_reproduce:
				advance_state()
				return
			target = get_nearest_creature(Rabbit)
			if is_instance_valid(target): 
				destination = target.position
			if move_towards_destination(delta):
				var new_rabbit = rabbit_scene.instantiate()
				new_rabbit.position = position + position.direction_to(destination) * 8
				add_sibling(new_rabbit)
				eat_counter = 0
				advance_state()
				return
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
	var direction = position.angle_to_point(destination)
	if direction < 0:
		direction += 2*PI
	$RabbitAnimation.set_flip_h(direction > PI/2 && direction < 3*PI/2 )
			
func updateAnimation():
	match current_state:
		STATE.SEEK_FOOD:
			sprite2d.play("Run")
		STATE.WAIT:
			sprite2d.play("Idle")
		STATE.RANDOM_WANDERING:
			sprite2d.play("Run")
		STATE.REPRODUCE_IF_ABLE:
			if eat_counter < feed_to_reproduce:
				sprite2d.play("Run")
			else:
				sprite2d.play("Love")
