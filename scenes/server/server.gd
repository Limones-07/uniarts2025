
## Handles all the game logic

class_name Server
extends Node

## The server's last scream to it's summoner... we're gone now.
## A critical error happened and we cannot proceed. 
signal last_scream

## Sends a packet to the peer `id` based on PacketBuilder
signal send_packet(packet_builder: PacketBuilder, id: int)

## The network interface received a packet. Deal with it.
signal received_packet(packet: Dictionary)

var port: int

@onready var _network_interface: ServerNetworkInterface = $NetworkInterface

func _ready() -> void:
	# This line looks like getting ready to unalive lol
	last_scream.connect(_last_scream) 
	received_packet.connect(_on_receive_packet)
	_setup_multiplayer_api()
	await _network_interface.init(port)
	_log("Ready!")

func _exit_tree() -> void:
	_log("Goodbye!")

func _log(msg: String) -> void:
	print("[Server] %s" % msg)

func _last_scream() -> void:
	# It was a good run, my brothers, but I fear it's come to an end.
	# May our souls reunite in the heavens.
	# Goodbye.
	_log("PANIC: There's nothing we can do, a critical failure happened.")
	queue_free()

func _setup_multiplayer_api() -> void:
	var scene_multiplayer = SceneMultiplayer.new()
	var self_path = self.get_path()
	self.get_tree().set_multiplayer(scene_multiplayer, self_path)
	_log("Set new MultiplayerAPI for server's node at %s!" % self_path)

func _on_receive_packet(packet: Dictionary) -> void:
	_log("Received packet: %s" % packet)
