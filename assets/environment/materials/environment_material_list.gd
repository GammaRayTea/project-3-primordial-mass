class_name EnvironmentMaterials extends Node
enum MATERIALS {
	TEST_CEILING,
	FLOOR_WOOD,
	FLOOR_COBBLE,
	WALL_PAPER,
	WALL_BRICK
	}


static var materials:Dictionary[int,NodePath] ={
MATERIALS.TEST_CEILING:"res://assets/environment/materials/test_ceiling.tres",
MATERIALS.FLOOR_WOOD:"res://assets/environment/materials/wood_floor_material.tres",
MATERIALS.WALL_PAPER:"res://assets/environment/materials/paper_wall_material.tres"
}




## get materials with the keys from [code]EnvironmentMaterials.FLOOR
static func get_material(_index:int) -> Material:
	var material:Material = load(materials[_index])
	return material
	
