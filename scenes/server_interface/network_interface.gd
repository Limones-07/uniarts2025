
## Handles the direct networking and packet processing.

extends Node

const DEFAULT_IP := "127.0.0.1"
const DEFAULT_PORT := 35565
var _peer: ENetMultiplayerPeer

@onready var _server_interface := self.get_parent() as Node
func _ready():
	_server_interface.init.connect(_interface_init)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	_log("Ready!")

func _log(msg: String) -> void:
	print("[ServerInterface/NetworkInterface] %s" % msg)

func _interface_init(ip := DEFAULT_IP, port := DEFAULT_PORT) -> void:
	_peer = ENetMultiplayerPeer.new()
	var error = _peer.create_client(ip, port)
	if not error:
		# Everything is alright
		multiplayer.multiplayer_peer = _peer
		return
	# Something went wrong...
	if error == ERR_ALREADY_IN_USE:
		_log("ERROR: How... how did this happen? The peer is fresh new...")
	elif error == ERR_CANT_CREATE:
		_log("ERROR: Failed to create the client peer, " + 
				"try again (probably an OS mess up).")
	_server_interface.err_create_client.emit()

func _on_connected_to_server() -> void:
	_log("Successfully connected to the server!")
	_server_interface.connected_to_server.emit()

func _on_connection_failed() -> void:
	_log("Connection to the server failed.")
	_server_interface.connection_failed.emit()

func _on_server_disconnected() -> void:
	_log("Disconnected from the server.")
	_server_interface.server_disconnected.emit()
