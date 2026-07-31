class_name EnvironmentMaterials extends Node
enum MATERIALS {
	TEST_CEILING,
	FLOOR_WOOD,
	FLOOR_METAL,
	WALL_PAPER,
	WALL_BRICK
	}

enum MATERIAL_SETS {
	SEVENTIES,
	BRICK
}
static var materials:Dictionary[int,NodePath] ={
MATERIALS.TEST_CEILING:"res://assets/environment/materials/test_ceiling.tres",
MATERIALS.FLOOR_WOOD:"res://assets/environment/materials/wood_floor_material.tres",
MATERIALS.WALL_PAPER:"res://assets/environment/materials/paper_wall_material.tres",
MATERIALS.WALL_BRICK:"res://assets/environment/materials/brick_wall_material.tres",
MATERIALS.FLOOR_METAL:"res://assets/environment/materials/metal_floor_material.tres",
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
	return array
## get materials with the keys from [code]EnvironmentMaterials.FLOOR
static func get_material(_index:MATERIALS) -> Material:
	var material:Material = load(materials[_index])
	return material
	
