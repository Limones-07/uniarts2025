class_name Enemy
extends CharacterBody3D

@export var SPEED = 4.0
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var sprite = $AnimatedSprite3D
var character
var outline = false
var character_sprites
const characters = ["crianca_otaria", "dona_bernadette", "lucian", "mikhail", "yuu", "gilberto"]
var dead = false
const self_scene = preload("res://scenes/prefabs/enemy/enemy.tscn")
var dir = Vector3(randi_range(-100, 100), 0, randi_range(-100, 100))

static func constructor(pos: Vector3 = Vector3(30, 0, 0), char: int = 0) -> Enemy:
	var enemy = self_scene.instantiate()
	enemy.position = pos
	enemy.character = characters[char]
	return enemy

func _ready() -> void:
	sprite.play(character)
	
	character_sprites = ["res://assets/png/NpcCriancaOtaria.png", "res://assets/png/NpcDonaBernadette.png", "res://assets/png/NpcLucian.png", "res://assets/png/NpcMikhail.png", "res://assets/png/NpcYuu.png", "res://assets/png/NpcGilberto.png"]
	dir.y = 0.0
	dir = dir.normalized()

func _physics_process(_delta: float) -> void:
	if dead:
		return
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
	
	velocity = dir * SPEED
	move_and_slide()
	
	if not outline:
		$AnimatedSprite3D.play(character)
	else:
		$AnimatedSprite3D.play(character + "_outline")
	
	outline = false
	
	if position.x < -29.0 or position.x > 29.0 or position.z < -29.0 or position.z > 29.0:
		kill()

func kill():
	dead = true
	$CollisionShape3D.disabled = true
	self.queue_free()

func get_character() -> int:
	return characters.find(character)
