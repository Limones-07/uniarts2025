
## Handles the clients' connection and network communication

extends Node

const MAX_CLIENTS: int = 4

var enet_peer: ENetMultiplayerPeer

@onready var _server = self.get_parent()

func _ready() -> void:
	_log("Ready!")

func init(PORT: int) -> void:
	_log("Initializing...")
	enet_peer = ENetMultiplayerPeer.new()
	var error: Error = enet_peer.create_server(PORT, MAX_CLIENTS)
	if error:
		# The network failed, there's no way to proceed. Critial error.
		_server.last_scream.emit()
		return
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(_new_connection)
	_log("Initialized with peer id %s!" % multiplayer.get_unique_id())

func _log(msg: String) -> void:
	print("[Server/NetworkInterface] %s" % msg)

func _new_connection(id: int) -> void:
	_log("Got a new connection from peer id %s!" % id)
	_log("Connected peers ids: %s." % multiplayer.get_peers())
	var peer: ENetPacketPeer = enet_peer.get_peer(id)
	_log("New peer's address and port: %s:%s." % [
		peer.get_remote_address(),
		peer.get_remote_port(),
	])
	
