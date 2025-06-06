
## Handles the direct networking and packet processing.

extends Node

const DEFAULT_IP: String = "127.0.0.1"
const DEFAULT_PORT: int = 35565
var _peer: ENetMultiplayerPeer

func _ready():
	ServerInterface.init.connect(_interface_init)
	ServerInterface.server_disconnect.connect(_disconnect)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	_log("Ready!")

func _log(msg: String) -> void:
	print("[ServerInterface/NetworkInterface] %s" % msg)

func _interface_init(ip := DEFAULT_IP, port := DEFAULT_PORT) -> void:
	_log("Initializing connection to server on %s:%s..." % [ip, port])
	_peer = ENetMultiplayerPeer.new()
	var error: Error = _peer.create_client(ip, port)
	if not error:
		# Everything is alright
		multiplayer.multiplayer_peer = _peer
		multiplayer.peer_packet.connect(_on_receive_packet)
		_log("Interface successfully initialized!")
		return
	# Something went wrong...
	if error == ERR_ALREADY_IN_USE:
		_log("ERROR: How... how did this happen? The peer is fresh new...")
	elif error == ERR_CANT_CREATE:
		_log("ERROR: Failed to create the client peer, " + 
				"try again (probably an OS mess up).")
	ServerInterface.err_create_client.emit()

func _disconnect() -> void:
	_log("Disconnecting from the server...")
	multiplayer.disconnect_peer(1)

func _send_packet(
		json_packet: String, 
		transfer_mode: MultiplayerPeer.TransferMode = _peer.TRANSFER_MODE_UNRELIABLE_ORDERED) -> void:
	var net_packet: PackedByteArray = json_packet.to_utf8_buffer()
	multiplayer.send_bytes(
			net_packet, 
			_peer.TARGET_PEER_SERVER,
			transfer_mode)

func _on_receive_packet(_id: int, net_packet: PackedByteArray) -> void:
	_log("Received packet!")
	var json_packet: String = net_packet.get_string_from_utf8()
	_log("Packet: %s" % json_packet)

func _on_connected_to_server() -> void:
	_log("Successfully connected to the server!")
	ServerInterface.connected_to_server.emit()

func _on_connection_failed() -> void:
	_log("Connection to the server failed.")
	ServerInterface.connection_failed.emit()

func _on_server_disconnected() -> void:
	_log("Disconnected from the server.")
	ServerInterface.server_disconnected.emit()
