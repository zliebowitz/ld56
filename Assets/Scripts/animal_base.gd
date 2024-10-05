class_name Animal
extends Node2D

enum Movement {WALKING, FLYING, SWIMMING}

@export var animal_name: String = "PLACEHOLDER"
@export var movement_mode: Movement = Movement.WALKING
@export var speed: float = 6
@export var starvation_time: float = 30
@export var cost: int = 1
@export var cost_scaling: float = 1.1

func create_currency() -> void:
	pass
