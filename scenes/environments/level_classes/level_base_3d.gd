## Serves as a base for all levels

class_name LevelBase3D
extends Node3D

## Initializes the Level by replacing all placeholders
func init(level_instance_data_json: String) -> void:
	if not is_node_ready():  # We need to be inside the scene tree to initialize
		await ready
	
	var level_instance_data := JSON.parse_string(level_instance_data_json) as Dictionary
	_check_if_not_null(level_instance_data,
			"Couldn't parse the level instance data as a Dictionary...")
	
	for group_path in level_instance_data.keys():
		var placeholder_group := get_node(group_path) as LevelPlaceholderGroup3D
		_check_if_not_null(placeholder_group, 
				"Couldn't get %s as a LevelPlaceholderGroup3D..." % group_path)
		placeholder_group.replace(level_instance_data[group_path])

## Bakes the Level by preparing the level instance data
func bake(seed_hash: int) -> String:
	var level_instance_data: Dictionary = {}
	var placeholder_groups := _get_placeholder_groups()
	
	for placeholder_group in placeholder_groups:
		var group_instance_data: String = placeholder_group.bake(seed_hash)
		var placeholder_group_path := get_path_to(placeholder_group).get_concatenated_names()
		level_instance_data[placeholder_group_path] = group_instance_data
	
	return JSON.stringify(level_instance_data)

## Loads itself as the current scene (use with caution)
func load_as_scene(tree: SceneTree) -> void:
	tree.current_scene.queue_free()
	tree.root.add_child(self)
	tree.current_scene = self
	self.owner = null

func _get_placeholder_groups() -> Array[LevelPlaceholderGroup3D]:
	var placeholder_groups: Array[LevelPlaceholderGroup3D] = []
	for node in find_children("*", "LevelPlaceholderGroup3D"):
		if node is not LevelPlaceholderGroup3D:
			push_error("How...?")
			OS.crash("") # Developer error, it must not go into the final build
		placeholder_groups.append(node as LevelPlaceholderGroup3D)
	return placeholder_groups

## Checks if a variant is null or not
func _check_if_not_null(variant: Variant, message: String) -> void:
	if not variant:
		push_error(message)
		OS.crash("")  # Developer error, it must not go into the final build
