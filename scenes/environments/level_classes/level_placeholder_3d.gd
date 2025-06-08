## Serves as the a placeholder to be substituted with a scene

class_name LevelPlaceholder3D
extends MeshInstance3D

## Replaces itself with a properly scaled Node3D
func replace(replacement_path: String) -> void:
	var parent: Node3D = get_parent()
	if parent is not LevelPlaceholderGroup3D:
		push_error("A LevelPlaceholder3D should be inside a LevelPlaceholderGroup3D!")
		OS.crash("")  # Developer error, it must not go into the final build
	
	var replacement = load(replacement_path) as PackedScene
	_check_if_not_null(replacement,
			"Tried to load something that isn't a PackedScene as one...")
	var replacement_instance: Node3D = replacement.instantiate() as Node3D
	_check_if_not_null(replacement_instance, 
			"A LevelPlaceholder3D should be replaced with a Node3D!")
	
	# It's time for the actual replacement
	replacement_instance.global_transform = self.global_transform
	self.add_sibling(replacement_instance)
	
	# Goodbye
	queue_free()

## Checks if a variant is null or not
func _check_if_not_null(variant: Variant, message: String) -> void:
	if not variant:
		push_error(message)
		OS.crash("")  # Developer error, it must not go into the final build
