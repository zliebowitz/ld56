class_name Fox
extends Animal

@onready var sprite2d = $FoxAnimation
@onready var timer = $Timer
var is_waiting = false
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	sprite2d.play("Run")


func _process(delta: float) -> void:
	super(delta)
	updateAnimation()
	match current_state:
		STATE.SEEK_WATER:
			destination = tilemap.get_nearest_tile_absolute(position, 2)
			if move_towards_destination(delta):
				advance_state()
		STATE.SEEK_FOOD:
			var target = get_nearest_creature(Squirrel)
			if (target != null):
				destination = target.position
			else:
				return
			if move_towards_destination(delta):
				target.kill()
				advance_state()
		STATE.WAIT:
			if has_time_passed():
				advance_state()
		STATE.RANDOM_WANDERING:
			if has_time_passed():
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


func _on_wait_timeout() -> void:
	is_waiting = false
	print("Wait state finished!")
