
## Handles the clients' connection and network communication.

extends Node

const MAX_CLIENTS: int = 4
const RETRY_TIME: float = 1.0
const INIT_RETRIES: int = 3

var enet_peer: ENetMultiplayerPeer

@onready var _server = self.get_parent()

func _ready() -> void:
	_log("Ready!")

func init(PORT: int) -> void:
	_log("Initializing...")
	for try in INIT_RETRIES:
		var error = await _try_create_server(PORT, try+1)
		if not error:
			break
		if try == 2:
			_server.last_scream.emit()
			return
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(_new_connection)
	multiplayer.peer_disconnected.connect(_on_peer_disconnect)
	_log("Initialized with peer id %s!" % multiplayer.get_unique_id())

func _try_create_server(PORT: int, try: int) -> int:
	enet_peer = ENetMultiplayerPeer.new()
	var error = enet_peer.create_server(PORT, MAX_CLIENTS)
	if error == OK:
		return 0
	elif error == ERR_CANT_CREATE:
		_log("WARNING: Couldn't create the server, probably an OS " +
			"problem. Waiting %s seconds before retrying... " % RETRY_TIME + 
			"(Try %s/%s)" % [try, INIT_RETRIES])
		await get_tree().create_timer(RETRY_TIME).timeout
		return 1
	## Something bad happened, there's no way to proceed.
	_server.last_scream.emit()
	return 1

func _exit_tree() -> void:
	if not multiplayer.has_multiplayer_peer():
		return
	var peers = multiplayer.get_peers()
	for peer_id in peers:
		_log("Disconnecting peer %s..." % peer_id)
		enet_peer.disconnect_peer(peer_id)

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

func _on_peer_disconnect(id: int) -> void:
	_log("Peer %s disconnected! Cya, %s! o/" % [id, id])
