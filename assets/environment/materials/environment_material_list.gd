class_name EnvironmentMaterials extends Node
enum MATERIALS {
	TEST_CEILING,
	FLOOR_WOOD,
	FLOOR_METAL,
	FLOOR_CONCRETE,
	FLOOR_OVERGROWN,
	WALL_PAPER,
	WALL_BRICK,
	WALL_ROCK_TILES,
	WALL_OVERGROWN
	}

enum MATERIAL_SETS {
	SEVENTIES,
	BRICK,
	BRUTALISM,
	OVERGROWN
}
static var materials:Dictionary[int,NodePath] ={
MATERIALS.TEST_CEILING:"res://assets/environment/materials/test_ceiling.tres",
MATERIALS.FLOOR_WOOD:"res://assets/environment/materials/wood_floor_material.tres",
MATERIALS.WALL_PAPER:"res://assets/environment/materials/paper_wall_material.tres",
MATERIALS.WALL_BRICK:"res://assets/environment/materials/brick_wall_material.tres",
MATERIALS.FLOOR_METAL:"res://assets/environment/materials/metal_floor_material.tres",
MATERIALS.FLOOR_CONCRETE:"res://assets/environment/materials/concrete_floor_material.tres",
MATERIALS.WALL_ROCK_TILES:"res://assets/environment/materials/rock_tiles_wall_material.tres",
MATERIALS.FLOOR_OVERGROWN:"res://assets/environment/materials/overgrown_floor_material.tres",
MATERIALS.WALL_OVERGROWN:"res://assets/environment/materials/overgrown_wall_material.tres"
}



static func get_material_set(mat_set:MATERIAL_SETS) -> Array:
	var array = []
	match mat_set:
		MATERIAL_SETS.SEVENTIES:
			array.append(get_material(MATERIALS.FLOOR_WOOD))
			array.append(get_material(MATERIALS.TEST_CEILING))
			array.append(get_material(MATERIALS.WALL_PAPER))
		MATERIAL_SETS.BRICK:
			array.append(get_material(MATERIALS.FLOOR_METAL))
			array.append(get_material(MATERIALS.TEST_CEILING))
			array.append(get_material(MATERIALS.WALL_BRICK))
		MATERIAL_SETS.BRUTALISM:
			array.append(get_material(MATERIALS.FLOOR_CONCRETE))
			array.append(get_material(MATERIALS.TEST_CEILING))
			array.append(get_material(MATERIALS.WALL_ROCK_TILES))
		MATERIAL_SETS.OVERGROWN:
			array.append(get_material(MATERIALS.FLOOR_OVERGROWN))
			array.append(get_material(MATERIALS.TEST_CEILING))
			array.append(get_material(MATERIALS.WALL_OVERGROWN))
	return array
## get materials with the keys from [code]EnvironmentMaterials.FLOOR
static func get_material(_index:MATERIALS) -> Material:
	var material:Material = load(materials[_index])
	return material
	
