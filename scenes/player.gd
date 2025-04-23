extends CharacterBody3D

@onready var ray_cast_3D = $RayCast3D
@onready var gun_sprite = $CanvasLayer/GunBase/AnimatedSprite2D
@export var SPEED = 5.0
@export var MOUSE_SENSITIVITY = 0.5
var can_shoot = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gun_sprite.animation_finished.connect(shoot_animation_done)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	
	if !can_shoot:
		return
	if Input.is_action_just_pressed("right_click"):
		shoot()

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func shoot():
	can_shoot = false
	gun_sprite.play("shoot")
	if ray_cast_3D.is_colliding() and ray_cast_3D.get_collider().has_method("kill"):
		ray_cast_3D.get_collider().kill()

func shoot_animation_done():
	can_shoot = true

func restart():
	get_tree().reload_current_scene()
