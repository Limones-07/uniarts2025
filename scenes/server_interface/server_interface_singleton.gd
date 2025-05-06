
## Provides an interface to communicate with the Game Server.
## This script is essentially a header file.

# TODO: Everything, proof of concept

extends Node

var sts: PackedScene = preload("res://scenes/server_testing_scene/server_testing_scene.tscn")

func _ready() -> void:
	var sts_instance: Node = sts.instantiate()
	self.add_child(sts_instance)
