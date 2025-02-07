extends Node
class_name LevelManager

# TODO: this is default random seed - replace with user input
const RANDOM_SEED : String = "GMTK2024"
const MAX_LEVEL : int = 5
# TODO: this should be dynamic but hardcoded for now
const tile_types = [
	Tile.TILE_TYPE.GRASS,
	Tile.TILE_TYPE.STONE,
	Tile.TILE_TYPE.WATER,
	Tile.TILE_TYPE.DIRT,
	Tile.TILE_TYPE.SNOW
]
var rng = RandomNumberGenerator.new()
var level = 1

# TODO: scale these with level?
# for AreaObjective
var min_area = 2
var max_area = 7

# for DimensionObjective
var min_dimension = 1
var max_dimension = 3

@onready var placement_layer = $"../PlacementLayer"

func finish_game():
	var blocks_placed : int = placement_layer.block_count
	print("level %d finished with %d blocks placed" % [level, blocks_placed])

func handle_objectives_finished():
	level += 1 # increment level count
	if level >= MAX_LEVEL:
		finish_game()

func _init() -> void:
	rng.seed = hash(RANDOM_SEED)

func get_random_dimension_objective() -> Objective:
	var width : int = rng.randi_range(min_dimension + level, max_dimension + level)
	var height : int = rng.randi_range(min_dimension + level, max_dimension + level)
	var tile_index : int = rng.randi_range(0, tile_types.size() - 1)
	var tile_type : Tile.TILE_TYPE = tile_types[tile_index]
	var tile_text : String
	match tile_type:
		Tile.TILE_TYPE.GRASS:
			tile_text = "Grass"
		Tile.TILE_TYPE.STONE:
			tile_text = "Stone"
		Tile.TILE_TYPE.WATER:
			tile_text = "Water"
		Tile.TILE_TYPE.SNOW:
			tile_text = "Snow"
		Tile.TILE_TYPE.DIRT:
			tile_text = "Dirt"
		_:
			tile_text = "Unknown"
			
	var objective = Objective.DimensionObjective.new(
		"Create a %s room with width %d and height %d" % [tile_text, width, height],
		tile_type,
		width,
		height
		)
	return objective

# returns a random objective
func get_random_area_objective() -> Objective:
	# random area
	var area : int = rng.randi_range(min_area + level, max_area + level)
	# random tile type
	var tile_index : int = rng.randi_range(0, tile_types.size() - 1)
	var tile_type : Tile.TILE_TYPE = tile_types[tile_index]
	
	var tile_text : String
	match tile_type:
		Tile.TILE_TYPE.GRASS:
			tile_text = "Grass"
		Tile.TILE_TYPE.STONE:
			tile_text = "Stone"
		Tile.TILE_TYPE.WATER:
			tile_text = "Water"
		Tile.TILE_TYPE.SNOW:
			tile_text = "Snow"
		Tile.TILE_TYPE.DIRT:
			tile_text = "Dirt"
		_:
			tile_text = "Unknown"
	
	var objective = Objective.AreaObjective.new(
		"Create a %s room with an area of %d" % [tile_text, area],
		tile_type,
		area,
		)
	return objective
