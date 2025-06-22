extends Control

const char_heads = ["res://assets/png/Untitled_Artwork-26.png", "res://assets/png/Untitled_Artwork-8 4.png", "res://assets/png/Untitled_Artwork-32.png", "res://assets/png/Untitled_Artwork-20.png", "res://assets/png/Untitled_Artwork-2 5.png", "res://assets/png/Untitled_Artwork-14.png"]
var explanation_scene = "res://scenes/ui/Explanation.tscn"
var main_scene = "res://scenes/environments/main.tscn"
var out_of_main = false

func _ready() -> void:
	if $"HSplitContainer/Container/UntitledArtwork-26" != null:
		$"HSplitContainer/Container/UntitledArtwork-26".texture = load(char_heads[randi_range(0, 5)])
		return
	
	out_of_main = true

func _on_button_pressed() -> void:
	if out_of_main:
		get_tree().change_scene_to_file(main_scene)
	else:
		get_tree().change_scene_to_file(explanation_scene)
