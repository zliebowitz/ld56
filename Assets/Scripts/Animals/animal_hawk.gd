class_name Hawk
extends Animal

@onready var animation = $AnimatedSprite2D

func _process_action(delta: float) -> void:
	if animation.animation == "Eat" && animation.is_playing():
		if time_in_state < 2:
			return
		
	updateAnimation()
	match current_state:
		STATE.SEEK_FOOD:
			target = get_nearest_creature_list([Squirrel, Rabbit])
			if is_instance_valid(target):
				destination = target.position
			if move_towards_destination(delta):
				if not is_instance_valid(target):
					return
				animation.play("Eat")
				target.kill()
				create_dna()
				advance_state()
		STATE.SEEK_ITEM:
			var nearest_tree_tile = tilemap.get_nearest_tile(position - Vector2.UP * 25, 3)
			destination = tilemap.get_tile_center(nearest_tree_tile) + Vector2.UP * 25
			if move_towards_destination(delta):
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
			
	# Flip sprite if the squirrel is facing the opposite direction
	var direction = position.angle_to_point(destination)
	if direction < 0:
		direction += 2*PI
	$AnimatedSprite2D.set_flip_h(direction > PI/2 && direction < 3*PI/2 )

func updateAnimation():
	match current_state:
		STATE.SEEK_FOOD:
			animation.play("Fly")
		STATE.SEEK_ITEM:
			animation.play("Fly")
		STATE.WAIT:
			animation.play("Idle")
