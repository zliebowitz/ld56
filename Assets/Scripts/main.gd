extends Node2D

var dna: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gain_dna(0) # noop at time of writing, but handles defaults that aren't 0.
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pass


func _on_gain_dna(dna_value: int) -> void:
	dna += dna_value
	$CanvasLayer/Currency/RichTextLabel.text = str(dna)
