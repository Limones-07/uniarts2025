
## Provides an interface to communicate with the Game Server.
## This script is essentially a header file.

extends Node

@warning_ignore_start("unused_signal")
# #=-=-=-=-=-=-=-=-=#
# #-= API signals =-#
# #=-=-=-=-=-=-=-=-=#
# Signals that provide an API to interact with the server.
# These are the signals that the client can emit in order
# to talk to the server.

## Spawns a server on this game instance. If an internal server already exists,
## it'll destroy the existing one and spawn another one.
## Should be connected to by the local client using init().
## By default, uses the port 35565/UDP, but another port can be specified.
signal spawn_server(port: int)

## Destroys the server for whatever reason you wanted. 
signal destroy_server

## Initializes the Interface by connecting to an existing server.
## By default, connects to 127.0.0.1:35565/UDP. If the server isn't
## internal, server_ip must be specified, but the server's port is probably
## 35565/UDP (default), so you don't need to specify it in most cases.
signal init(server_ip: String, server_port: int)

## Disconnects from the server. If it isn't connected, do nothing.
signal server_disconnect

# #=-=-=-=-=-=-=-=-=-=-=-=#
# #-= Reporting signals =-#
# #=-=-=-=-=-=-=-=-=-=-=-=#
# Signals that represent the server's or the interface's response
# to some kind of event.
# These are the signals that the client should connect to in order
# to receive the server's response.

## The internal server is ready.
signal server_ready

## The internal server got queued to be freed. 
## Be ready for the iminent server's destruction.
signal server_destroying

## There is no more internal server. It's gone, poof.
signal server_destroyed

## Something went really wrong on the creation of the client, emit init() again.
signal err_create_client

## Successfully connected to the server.
signal connected_to_server

## Failed to connect to the server, you should emit init() again. 
## If the connection to 127.0.0.1 failed, it's probably a server problem, you
## should emit destroy_server() and redo everything.
signal connection_failed

## Disconnected from the server.
## If this signal was emmited, you should emit init() again.
signal server_disconnected
@warning_ignore_restore("unused_signal")

func _ready() -> void:
	print("[ServerInterface] Ready!")
