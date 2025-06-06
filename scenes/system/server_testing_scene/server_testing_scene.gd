
## Tests the server interface/server communication.

extends Node

@export var CONNECTION_TEST: bool = false
@export var COMMUNICATION_TEST: bool = false

func _ready() -> void:
	_log("Starting testing sequence. Good luck!\n")
	if CONNECTION_TEST:
		await _test_defaults()
		await _test_defaults_2()
		await _test_localhost()
		await _test_different_port()
		await _test_non_defaults()
		await _test_disconnect_and_restart()
	if COMMUNICATION_TEST:
		await _test_send_packet(JSON.stringify({
				"type": "sync",
				"entities": [
					"Lina",
					"Dante",
					"Iris",
				],
			}))
	_log("Testing complete!")

func _test_send_packet(json_packet: String) -> void:
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	ServerInterface.init.emit()
	await _wait()
	_log("Sending the packet: %s" % json_packet)
	var ni: Node = ServerInterface.get_node("/root/ServerInterface/NetworkInterface")
	ni._send_packet(json_packet)
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _test_defaults() -> void:
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	ServerInterface.init.emit()
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _test_defaults_2() -> void:
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	ServerInterface.init.emit()
	await _wait()
	_log("Reloading the main scene...")
	self.get_tree().change_scene_to_file("res://scenes/environments/main.tscn")
	_log("Waiting 10 seconds...")
	await _wait(10)
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _test_localhost() -> void:
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface on address localhost with default " +
			"port (35565)...")
	ServerInterface.init.emit("localhost")
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")
	
func _test_different_port() -> void:
	_log("Spawning server with port 35575...")
	ServerInterface.spawn_server.emit(35575)
	await _wait()
	_log("Initializing the interface on address 127.0.0.1:35575...")
	ServerInterface.init.emit("127.0.0.1", 35575)
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _test_non_defaults() -> void:
	_log("Spawning server with port 35575...")
	ServerInterface.spawn_server.emit(35575)
	await _wait()
	_log("Initializing the interface on address localhost:35575...")
	ServerInterface.init.emit("localhost", 35575)
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _test_disconnect_and_restart() -> void:
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	ServerInterface.init.emit()
	await _wait()
	_log("Spawning server with default value (port 35565)...")
	ServerInterface.spawn_server.emit()
	await _wait()
	_log("Initializing the interface with default values (127.0.0.1:35565)...")
	ServerInterface.init.emit()
	await _wait()
	_log("Disconnecting...")
	ServerInterface.server_disconnect.emit()
	await _wait()
	_log("Destroying the server...")
	ServerInterface.destroy_server.emit()
	await ServerInterface.server_destroyed
	_log("\n")

func _wait(time_sec: float = 1.0) -> void:
	await get_tree().create_timer(time_sec).timeout

func _log(msg: String) -> void:
	print("[ServerTestingScene] %s" % msg)
