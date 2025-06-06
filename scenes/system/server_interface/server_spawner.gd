
## Spawns the internal server. That's it.
## I like to think of it as a sorcerer that knows a ritual to summon an entity
## from the deepest of the seven hells called Game Server lol. 

extends Node

const DEFAULT_PORT: int = 35565

var _server_instance: Server

func _ready() -> void:
	ServerInterface.spawn_server.connect(_spawn_server)
	ServerInterface.destroy_server.connect(_destroy_server)
	_log("Ready!")

func _log(msg: String) -> void:
	print("[ServerInterface/ServerSpawner] %s" % msg)

func _spawn_server(port: int = DEFAULT_PORT) -> void:
	if _server_instance != null and is_instance_valid(_server_instance):
		_log("Restarting the existing server...")
		ServerInterface.destroy_server.emit()
		await ServerInterface.server_destroyed
	_log("Spawning server with listener port %s..." % port)
	var server_scene: PackedScene = load("res://scenes/system/server/server.tscn")
	_server_instance = server_scene.instantiate() as Server
	_server_instance.port = port
	_server_instance.ready.connect(
		func(): ServerInterface.server_ready.emit()
	)
	_server_instance.last_scream.connect(_on_last_scream)
	_server_instance.tree_exited.connect(_on_server_destroyed)
	ServerInterface.add_child(_server_instance)
	_log("Server spawned!")

func _destroy_server() -> void:
	_server_instance.queue_free()
	_log("Queued the internal server destruction.")
	ServerInterface.server_destroying.emit()

func _on_last_scream() -> void:
	_log("CRITICAL: The server panicked and is destroying itself.")
	ServerInterface.server_destroying.emit()

func _on_server_destroyed() -> void:
	_log("The internal server was succesfully destroyed.")
	_server_instance = null
	ServerInterface.server_destroyed.emit()
