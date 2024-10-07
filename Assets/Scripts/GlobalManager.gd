extends Node

var tilemap: WorldMapLayer
var main: Node2D
var population_hud: CanvasLayer
var questlog: QuestLog
		
var creature_count: int = 0

func initialize():
	tilemap = get_tree().root.get_node("Main/TileMapLayer")
	main = get_tree().root.get_node("Main")
	population_hud = get_tree().root.get_node("Main/PopulationHUD")
	questlog = get_tree().root.get_node("Main/CanvasLayer/QuestLog")

func update_populations():
	population_hud.update_populations()
	questlog.check_quests()
