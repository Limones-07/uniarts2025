
## Manages the active level for the game. Deals with the players via
## PlayerController, save files, entities, world, events, etc.

class_name LevelManager
extends Node

## Saves the game state for future loading
func save_game() -> void:
	pass

## Loads the game state
func load_game() -> void:
	pass

func _ready() -> void:
	_log("Ready!")

func _log(msg: String) -> void:
	print("[Server/LevelManager] %s" % msg)
