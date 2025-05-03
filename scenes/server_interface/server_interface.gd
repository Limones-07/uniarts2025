
## Provides an interface to communicate with the Game Server.
## This script is essentially a header file.

extends Node

# #=-=-=-=-=-=-=-=-=#
# #-= API signals =-#
# #=-=-=-=-=-=-=-=-=#
# Signals that provide an API to interact with the server.
# These are the signals that the client can emit in order
# to talk to the server.

## Initializes the Interface by connecting to an existing server.
## By default, connects to 127.0.0.1:35565/UDP. If the server isn't
## internal, server_ip must be specified, but the server's port is probably
## 35565/UDP (default), so you don't need to specify it in most cases.
signal init(server_ip: String, server_port: int)

## Spawns a server on this game instance.
## Should be connected to by the local client using init().
## By default, uses the port 35565/UDP, but another port can be specified.
signal spawn_server(port: int)

# #=-=-=-=-=-=-=-=-=-=-=-=#
# #-= Reporting signals =-#
# #=-=-=-=-=-=-=-=-=-=-=-=#
# Signals that represent the server's or the interface's response
# to some kind of event.
# These are the signals that the client should connect to in order
# to receive the server's response.

## Successfully connected to the server.
signal connected_to_server

## Failed to connect to the server (deal with it, client).
signal connection_failed

## Disconnected from the server.
## If this signal was emmited, you should emit init() again.
signal server_disconnected

## Something went really wrong on the creation of the client, emit init() again.
signal err_create_client


func _ready() -> void:
	print("[ServerInterface] Ready!")
