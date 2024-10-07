class_name QuestLog
extends ItemList

@export var all_quests: Array[Quest]
@export var active_quests: Array[Quest]

@onready var population_hud = GlobalManager.population_hud

func _ready() -> void:
	add_next_quest()

func check_quests() -> void:
	for quest: Quest in active_quests:
		var successful = true
		for requirement in quest.requirements:
			var animal = requirement
			var number = quest.requirements.get(requirement)
			if population_hud.get(animal) >= number:
				continue
			else: successful = false
		if successful:
			var index = active_quests.find(quest)
			active_quests.remove_at(index)
			remove_item(index)
			add_next_quest()

func add_next_quest() -> void:
	var new_quest: Quest = all_quests.pop_front()
	if not new_quest: 
		print("No more quests!")
		return
	active_quests.append(new_quest)
	add_item(new_quest.text, new_quest.image, false)
	
