class_name Main

extends Node2D

var dna: int = 1;


func _ready() -> void:
	_on_gain_dna(20000) # noop at time of writing, but handles defaults that aren't 0.


func _on_gain_dna(dna_value: int) -> void:
	dna += dna_value
	$CanvasLayer/Currency/CurrencyCount.text = str(dna)
