class_name Main

extends Node2D

var dna: int = 50;



func _ready() -> void:
	_on_gain_dna(0) # noop at time of writing, but handles defaults that aren't 0.


func _on_gain_dna(dna_value: int) -> void:
	dna += dna_value
	$CanvasLayer/Currency/CurrencyCount.text = str(dna)
