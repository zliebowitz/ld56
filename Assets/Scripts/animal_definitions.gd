class_name AnimalDefinition

static var name = {
	0: "Squirrel",
	1: "Hawk",
	2: "Fox",
	3: "Alligator",
	4: "Rabbit"
}

static var base_cost = {
	"Squirrel": 1,
	"Hawk": 2,
	"Fox": 3,
	"Alligator": 5,
	"Rabbit": 8
}

static var cost_scale = {
	"Squirrel": 1.1,
	"Hawk": 1.1,
	"Fox": 1.1,
	"Alligator": 1.1,
	"Rabbit": 1.1
}

static func cost_from_id(animal_id: int, animal_count:int) -> int:
	var animal_name =  AnimalDefinition.name
	return cost_from_name(animal_name, animal_count)
	
static func cost_from_name(animal_name: String, animal_count:int) -> int:
	var animal_base_cost = AnimalDefinition.base_cost[animal_name]
	var animal_cost_scale = AnimalDefinition.cost_scale[animal_name]
	var current_cost: int = animal_base_cost * pow(animal_cost_scale, animal_count)
	return current_cost
 
