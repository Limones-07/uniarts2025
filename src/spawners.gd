extends Node3D

@onready var enemy_scene = load("res://scenes/prefabs/enemy/enemy.tscn")
@onready var self_node = $"."
@export var spawn_prob_min: float = 80.0

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	var spawn_prob = randf_range(0.0, 100.0)
	if spawn_prob < spawn_prob_min:
		return
	
	var selected_character = randi_range(0, 5)
	var direction = Vector3(randi_range(-100, 100), 0, randi_range(-100, 100)).normalized()
	var pos = direction * 30
	pos.y = 0
	self_node.add_child(Enemy.constructor(pos, selected_character))
