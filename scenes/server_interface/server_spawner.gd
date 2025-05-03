
## Spawns the internal server. That's it.
## I like to think of it as a sorcerer that knows a ritual to summon an entity
## from the deepest of the seven hells called Game Server lol. 

extends Node

@onready var _server_interface := self.get_parent() as Node

func _ready() -> void:
	_server_interface.spawn_server.connect(_spawn_server)
	_log("Ready!")

func _log(msg: String) -> void:
	print("[ServerInterface/ServerSpawner] %s" % msg)

func _spawn_server() -> void:
	_log("Spawning server...")
	var server_scene = load("res://scenes/server/server.tscn")
	var server_instance = server_scene.instantiate()
	_server_interface.add_child(server_instance)
	_log("Server spawned!")
