class_name AnimalDefinition

enum {
	ANIMAL_SQUIRREL = 0,
	ANIMAL_HAWK = 1,
	ANIMAL_FOX = 2,
	ANIMAL_ALLIGATOR = 3,
	ANIMAL_RABBIT = 4,
	ANIMAL_BEAR = 5,
	ANIMAL_VULTURE = 6
}

static var name = {
	0: "Squirrel",
	1: "Hawk",
	2: "Fox",
	3: "Alligator",
	4: "Rabbit",
	5: "Bear",
	6: "Vulture"
}

static var base_cost = {
	"Squirrel": 10,
	"Hawk": 200,
	"Fox": 100,
	"Alligator": 5,
	"Rabbit": 150,
	"Bear": 500,
	"Vulture": 20
}

static var cost_scale = {
	"Squirrel": 1.2,
	"Hawk": 1.2,
	"Fox": 1.2,
	"Alligator": 1.2,
	"Rabbit": 1.5,
	"Bear": 1.2,
	"Vulture": 1.5
}

static func cost_from_id(animal_id: int, animal_count:int) -> int:
	var animal_name =  AnimalDefinition.name
	return cost_from_name(animal_name, animal_count)
	
static func cost_from_name(animal_name: String, animal_count:int) -> int:
	var animal_base_cost = AnimalDefinition.base_cost[animal_name]
	var animal_cost_scale = AnimalDefinition.cost_scale[animal_name]
	var current_cost: int = animal_base_cost * pow(animal_cost_scale, animal_count)
	return current_cost
 
