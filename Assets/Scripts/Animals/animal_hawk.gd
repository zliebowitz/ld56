class_name Hawk
extends Animal

@onready var animation = $AnimatedSprite2D
var target: Animal

func _process_action(delta: float) -> void:
	updateAnimation()
	match current_state:
		STATE.SEEK_FOOD:
			target = null
			target = get_nearest_creature_list([Squirrel, Rabbit])
			if target:
				destination = target.position
			else: destination = position
			if move_towards_destination(delta):
				if not target:
					return
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

func updateAnimation():
	match current_state:
		STATE.SEEK_FOOD, STATE.SEEK_ITEM:
			animation.play("Fly")
		STATE.WAIT:
			animation.play("Idle")
