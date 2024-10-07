class_name Quest
extends Resource

#Requirements are an array of [Class, number]
@export var image: Texture2D
@export var requirements: Dictionary = {}
@export var unlock: Array[String]
@export var dna_reward: int
@export var text: String
