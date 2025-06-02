
## Tests the server interface/server communication.

extends Node

@onready var _server_interface = ServerInterface

# OBS: Please only use when testing the server. Leaving this functional by default
# greatly impacts the development cycle, as it automatically changes scenes in the middle
# of testing sequences.

#func _ready() -> void:
	#_log("Starting testing sequence. Good luck!\n")
	#await _test_defaults()
	#_log("\n")
	#await _test_defaults_2()
	#_log("\n")
	#await _test_localhost()
	#_log("\n")
	#await _test_different_port()
	#_log("\n")
	#await _test_non_defaults()
	#_log("\n")
	#await _test_disconnect_and_restart()
	#_log("\n")
	#_log("Testing complete!")

func _test_defaults() -> void:
	_log("Spawning server with default value (port 35565)...")
	_server_interface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	_server_interface.init.emit()
	await _wait()
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed
	#await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

func _test_defaults_2() -> void:
	_log("Spawning server with default value (port 35565)...")
	_server_interface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	_server_interface.init.emit()
	await _wait()
	_log("Reloading the main scene...")
	self.get_tree().change_scene_to_file("res://scenes/environments/main.tscn")
	_log("Waiting 10 seconds...")
	await _wait(10)
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed
	#await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

func _test_localhost() -> void:
	_log("Spawning server with default value (port 35565)...")
	_server_interface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface on address localhost with default " +
			"port (35565)...")
	_server_interface.init.emit("localhost")
	await _wait()
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed
	#await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()
	
func _test_different_port() -> void:
	_log("Spawning server with port 35575...")
	_server_interface.spawn_server.emit(35575)
	await _wait()
	_log("Initializing the interface on address 127.0.0.1:35575...")
	_server_interface.init.emit("127.0.0.1", 35575)
	await _wait()
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed
	#await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

func _test_non_defaults() -> void:
	_log("Spawning server with port 35575...")
	_server_interface.spawn_server.emit(35575)
	await _wait()
	_log("Initializing the interface on address localhost:35575...")
	_server_interface.init.emit("localhost", 35575)
	await _wait()
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed
	#await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

func _test_disconnect_and_restart() -> void:
	_log("Spawning server with default value (port 35565)...")
	_server_interface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	_server_interface.init.emit()
	await _wait()
	_log("Spawning server with default value (port 35565)...")
	_server_interface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	_server_interface.init.emit()
	await _wait()
	_log("Disconnecting...")
	_server_interface.server_disconnect.emit()
	await _wait()
	_log("Destroying the server...")
	_server_interface.destroy_server.emit()
	await _server_interface.server_destroyed

func _wait(time_sec: float = 1.0) -> void:
	await get_tree().create_timer(time_sec).timeout

#func _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail() -> void:
	#_log("We are giving some time to the os so socket binding on the same port of last time doesnt fail.\n")
	#await _wait(5)

func _log(msg: String) -> void:
	print("[ServerTestingScene] %s" % msg)
