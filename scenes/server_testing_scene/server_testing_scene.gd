
## Tests the server interface/server communication.

extends Node

@onready var _server_interface = $ServerInterface

func _ready() -> void:
	_log("Starting testing sequence. Good luck!\n")
	await _test_defaults()
	await _test_localhost()
	await _test_different_port()
	await _test_non_defaults()
	_log("Testing complete!")

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
	await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

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
	await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()
	
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
	await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

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
	await _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail()

func _wait(time_sec: float = 1.0) -> void:
	await get_tree().create_timer(time_sec).timeout

func _give_some_time_to_the_os_so_socket_binding_on_the_same_port_of_last_time_doesnt_fail() -> void:
	_log("We are giving some time to the os so socket binding on the same port of last time doesnt fail.\n")
	await _wait(5)

func _log(msg: String) -> void:
	print("[ServerTestingScene] %s" % msg)
