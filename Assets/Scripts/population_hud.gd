class_name PopulationHUD
extends CanvasLayer

@export var squirrel_node: Node
@export var hawk_node: Node
@export var fox_node: Node
@export var bear_node: Node
@export var rabbit_node: Node
@export var alligator_node: Node
@export var corpse_node: Node

var squirrels: int = 0
var hawks: int = 0
var foxes: int = 0
var bears: int = 0
var rabbits: int = 0
var alligators: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_populations() -> void:
	alligators = alligator_node.get_child_count()
	foxes = fox_node.get_child_count()
	squirrels = squirrel_node.get_child_count()
	bears = bear_node.get_child_count()
	rabbits = rabbit_node.get_child_count()
	hawks = hawk_node.get_child_count()
	
	$GridContainer/AlligatorPop.text = str(alligator_node.get_child_count())
	$GridContainer/SquirrelPop.text = str(squirrel_node.get_child_count())
	$GridContainer/FoxPop.text = str(fox_node.get_child_count())
	$GridContainer/BearPop.text = str(bear_node.get_child_count())
	$GridContainer/RabbitPop.text = str(rabbit_node.get_child_count())
	$GridContainer/HawkPop.text = str(hawk_node.get_child_count())
	$GridContainer/CorpsePop.text = str(corpse_node.get_child_count())
