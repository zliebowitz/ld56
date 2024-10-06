class_name Fox
extends Animal

@onready var animation = $FoxAnimation
var count = 0

func _process_action(delta: float) -> void:
	if animation.animation == "Sleep" && animation.is_playing():
		if time_in_state < 3:
			return
	
	updateAnimation()
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
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
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			if has_time_passed():
				advance_state()
			else:
				if (fmod(time_in_state, 2.0) < 0.01):
					destination =  Vector2(position.x + randf_range(-50, 50), position.y + randf_range(-50, 50))
				
				if (move_towards_destination(delta)):
					animation.play("Default")
		STATE.PATROL:
			if (time_in_state > 4):
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
		
func updateAnimation():
	match current_state:
		STATE.SEEK_WATER, STATE.SEEK_FOOD:
			animation.play("Run")
		STATE.WAIT:
			animation.play("Eat")
		STATE.RANDOM_WANDERING:
			animation.play("Run")
		STATE.PATROL:
			animation.play("Sleep")
