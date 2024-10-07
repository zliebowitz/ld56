class_name TileDefinition

enum {
	TILE_GRASS = 0,
	TILE_SAND = 1,
	TILE_WATER = 2,
	TILE_TREE = 3,
	TILE_DREY = 4
}

static var tile_placed_count: int = 0;

static var name = {
	0: "Grass",
	1: "Sand",
	2: "Water",
	3: "Tree",
	4: "Drey"
}

static var base_cost = {
	"Grass": 1,
	"Sand": 1,
	"Water": 1,
	"Tree": 5,
	"Drey": 2
}

static var cost_scale = {
	"Grass": 1.2,
	"Sand": 1.1,
	"Water": 1.2,
	"Tree": 1.3,
	"Drey": 1.3
}

static var sprite_ids = {
	0: "Acorn"
}

static func cost_from_id(tile_id: int) -> int:
	var tile_name =  TileDefinition.name[tile_id]
	return cost_from_name(tile_name)
	
static func cost_from_name(tile_name: String) -> int:
	var tile_base_cost = TileDefinition.base_cost[tile_name]
	var tile_cost_scale = TileDefinition.cost_scale[tile_name]
	var current_cost: int = tile_base_cost * pow(tile_cost_scale, tile_placed_count)
	return current_cost
