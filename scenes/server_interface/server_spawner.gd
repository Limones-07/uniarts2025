
## Spawns the internal server. That's it.
## I like to think of it as a sorcerer that knows a ritual to summon an entity
## from the deepest of the seven hells called Game Server lol. 

extends Node

const DEFAULT_PORT: int = 35565

@onready var _server_interface := self.get_parent() as Node

func _ready() -> void:
	_server_interface.spawn_server.connect(_spawn_server)
	_log("Ready!")

func _log(msg: String) -> void:
	print("[ServerInterface/ServerSpawner] %s" % msg)

func _spawn_server(port := DEFAULT_PORT) -> void:
	_log("Spawning server with listener port %s..." % port)
	var server_scene: PackedScene = load("res://scenes/server/server.tscn")
	var server_instance: Node = server_scene.instantiate()
	server_instance.PORT = port
	_server_interface.add_child(server_instance)
	_log("Server spawned!")
