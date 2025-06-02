extends CharacterBody3D

@export var SPEED = 2.0
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var sprite = $AnimatedSprite3D
var dead = false

func _physics_process(_delta: float) -> void:
	if dead:
		return
	if player == null:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * SPEED
	move_and_slide()

func kill():
	dead = true
	sprite.play("die")
	$CollisionShape3D.disabled = true
