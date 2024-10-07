extends CanvasLayer

@export var squirrels: Node
@export var hawks: Node
@export var fox: Node
@export var bear: Node
@export var rabbit: Node
@export var alligator: Node
@export var corpses: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$GridContainer/AlligatorPop.text = str(alligator.get_child_count())
	$GridContainer/SquirrelPop.text = str(squirrels.get_child_count())
	$GridContainer/FoxPop.text = str(fox.get_child_count())
	$GridContainer/BearPop.text = str(bear.get_child_count())
	$GridContainer/RabbitPop.text = str(rabbit.get_child_count())
	$GridContainer/HawkPop.text = str(hawks.get_child_count())
	$GridContainer/CorpsePop.text = str(corpses.get_child_count())
