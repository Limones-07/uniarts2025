
## Manages all the connected players for the server

class_name PlayerController
extends Node

class _Player:
	var name: String = ""

@onready var _server: Server = self.get_parent()

var _room_player_number: int = 1
var _players: Dictionary[int, _Player] = {}

func init(room_player_number: int) -> void:
	self.room_player_number = room_player_number
	multiplayer.peer_connected.connect(_on_new_connection)

func _log(msg: String) -> void:
	print("[Server/PlayerController] %s" % msg)

func _ready() -> void:
	_log("Ready!")

func _on_new_connection(peer_id: int) -> void: 
	_log("Got a new player connected! Peer id: %s." % peer_id)
	# pb: PacketBuilder declaration
	var pb: PacketBuilder
	
	# Checks if the room is full
	if _players.size() == _room_player_number:
		# TODO: Write test
		pb = PacketBuilder.new(PacketBuilder.PacketTypes.SYNC)
		pb.add_attribute(PacketBuilder.SyncAttribute.LEVEL, "")
		pb.add_attribute(PacketBuilder.SyncAttribute.ERROR, "Room is full!")
		_server.send_packet.emit(pb, peer_id)
		multiplayer.disconnect_peer(peer_id)
		return
	# All right, let's begin the fun
	_players[peer_id] = _Player.new()
	
	# Sends lobby level + every player to newly connected client
	# TODO: Write test
	pb = PacketBuilder.new(PacketBuilder.PacketTypes.SYNC)
	pb.add_attribute(PacketBuilder.SyncAttribute.LEVEL, "lobby")
	var player_names: PackedStringArray = []
	for player in _players:
		player_names.append(_players[player].name)
	pb.add_attribute(PacketBuilder.SyncAttribute.PLAYERS, player_names)
	_server.send_packet.emit(pb, peer_id)
	
	# Sends updates player list to all clients except the new one
	# TODO: Write test
	pb = PacketBuilder.new(PacketBuilder.PacketTypes.SYNC)
	pb.add_attribute(PacketBuilder.SyncAttribute.PLAYERS, player_names)
	_server.send_packet.emit(pb, -peer_id)
