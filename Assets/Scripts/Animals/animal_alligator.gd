class_name Alligator
extends Animal

@onready var animation = $AnimatedSprite2D

func _process_action(delta: float) -> void:
	if animation.animation == "Eat" && animation.is_playing():
		if time_in_state < 2:
			return

	match current_state:
		STATE.SEEK_FOOD:
			target = get_nearest_creature_list([Squirrel, Rabbit, Fox])
			if is_instance_valid(target):
				$AnimatedSprite2D.animation = "Run"
				destination = target.position
			if move_towards_destination(delta):
				if not is_instance_valid(target):
					return
				target.kill()
				create_dna()
				advance_state()
		STATE.SEEK_WATER:
			var destination_tile = tilemap.get_nearest_tile(position, 2)
			destination = tilemap.get_tile_center(destination_tile)
			$AnimatedSprite2D.animation = "Run"
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT:
			$AnimatedSprite2D.animation = "Float"
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
			
	# Flip sprite if the squirrel is facing the opposite direction
	var direction = position.angle_to_point(destination)
	if direction < 0:
		direction += 2*PI
	$AnimatedSprite2D.set_flip_h(direction > PI/2 && direction < 3*PI/2 )
