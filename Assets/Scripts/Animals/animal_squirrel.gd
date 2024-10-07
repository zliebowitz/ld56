class_name Squirrel
extends Animal
	
@export var max_drey_tile_distance: int = 4

var wander_wait: float = 2.0
var reproducing: bool = false

func _process_action(delta: float) -> void:
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			$AnimatedSprite2D.animation = "run"
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			destination = tilemap.get_nearest_tile_absolute(position, -1, 0)
			if destination.x < 0 and destination.y < 0 and $AnimatedSprite2D.animation != "idle":
				$AnimatedSprite2D.play("idle")
				return
			if not(destination.x < 0 and destination.y < 0):
				$AnimatedSprite2D.play("run")
			if move_towards_destination(delta):
				create_dna()
				var coords = tilemap.get_coord_from_position(destination)
				tilemap.clear_sprite(coords)
				advance_state()
		STATE.WAIT:
			$AnimatedSprite2D.animation = "idle"
			if has_time_passed():
				advance_state()
		STATE.REPRODUCE_IF_ABLE:
			var drey_position = tilemap.get_nearest_tile_absolute(position, 4)
			if not tilemap.is_in_bounds(tilemap.get_coord_from_position(drey_position)) and not reproducing:
				$AnimatedSprite2D.animation = "idle"
				return
			#If too far from a Drey
			destination = drey_position
			if destination.distance_to(position) > max_drey_tile_distance * 32 and not reproducing:
				advance_state()
				return
			reproducing = true
			$AnimatedSprite2D.animation = "run"
			if move_towards_destination(delta):
				var destination_tile = tilemap.get_coord_from_position(destination)
				var drey_scene: SquirrelDrey = tilemap.get_tile_scene(destination_tile)
				if drey_scene != null:
					drey_scene.spawn_squirrel(self)
				reproducing = false
				advance_state()
				return
			if has_time_passed():
				reproducing = false
				advance_state()
		STATE.RANDOM_WANDERING:
			if wander_wait > 1.0:
				var new_destination = Vector2(position.x + randf_range(-50, 50), position.y + randf_range(-50, 50))
				#If a valid tile
				var coord = tilemap.get_coord_from_position(new_destination)
				if tilemap.is_in_bounds(coord) and tilemap.get_tile_info(coord)[0] != 2:
					destination = new_destination
				else: 
					destination = position
				wander_wait = 0.0
				
			if position.distance_to(destination) <= 8 and destination > Vector2(-900, -900):
				$AnimatedSprite2D.animation = "idle"
			else:
				$AnimatedSprite2D.animation = "run"
			
			if move_towards_destination(delta):
				wander_wait += delta
			if has_time_passed():
				wander_wait = 2.0
				advance_state()
		var unknown_state:
			print("Got state ", unknown_state," for ", animal_name, ", and does not know what to do!!!")
	
	# Flip sprite if the squirrel is facing the opposite direction
	var direction = position.angle_to_point(destination)
	if direction < 0:
		direction += 2*PI
	$AnimatedSprite2D.set_flip_h(direction > PI/2 && direction < 3*PI/2 )
