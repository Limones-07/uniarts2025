## Serves as a way to group placeholders of the same kind

class_name LevelPlaceholderGroup3D
extends Node3D

@export_file("*.tscn", "*.scn") var replacements_path: PackedStringArray

## Bake this group and return its instance data
func bake(seed_hash: int) -> String:
	var group_instance_data: Dictionary = {}
	
	var placeholders: Array[LevelPlaceholder3D] = []
	for child in get_children():
		if child is LevelPlaceholder3D:
			placeholders.append(child)
	
	if placeholders.size() != replacements_path.size():
		push_error("There are not enough replacements for all placeholders!")
		OS.crash("")  # Developer problem, it must not go to the final build
	
	# Before you judge me based on the comment below, this code wasn't made by
	# ChatGPT, even though it looks like it was.
	# Fisher-Yates shuffle for placeholder assigning
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_hash
	var replacements: PackedStringArray = replacements_path.duplicate() 
	# `replacements` is still an array of paths
	for i in range(replacements.size() - 1, 0, -1):
		var j = rng.randi_range(0, i)
		var tmp = replacements[i]
		replacements[i] = replacements[j]
		replacements[j] = tmp
	
	for i in placeholders.size():
		var path := get_path_to(placeholders[i]).get_concatenated_names()
		group_instance_data[path] = replacements[i]
	
	return JSON.stringify(group_instance_data)

## Replace all placeholders with the real objects
func replace(group_instance_data_json: String) -> void:
	var group_instance_data := JSON.parse_string(group_instance_data_json) as Dictionary
	_check_if_not_null(group_instance_data, 
			"Couldn't parse the group instance data as a Dictionary...")
	
	for placeholder_path in group_instance_data.keys():
		var placeholder := get_node(placeholder_path) as LevelPlaceholder3D
		_check_if_not_null(placeholder, 
				"Couldn't get %s as a LevelPlaceholder3D..." % placeholder_path)
		placeholder.replace(group_instance_data[placeholder_path])

## Checks if a variant is null or not
func _check_if_not_null(variant: Variant, message: String) -> void:
	if not variant:
		push_error(message)
		OS.crash("")  # Developer error, it must not go into the final build
