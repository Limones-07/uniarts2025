extends Control

func _ready() -> void:
	$VBoxContainer/Label2.text = "Pontos: " + str(get_node("/root/Global").points)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/environments/main.tscn")
