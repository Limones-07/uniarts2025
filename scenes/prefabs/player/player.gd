extends CharacterBody3D

@export var SPEED = 5.0
@export var MOUSE_SENSITIVITY = 0.5
var dead = false
var target
var points = 0
@onready var global = get_node("/root/Global")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	target = randi_range(0, 5)
	const characters = ["crianca_otaria", "dona_bernadette", "lucian", "mikhail", "yuu", "gilberto"]
	$GUI/Label.text = "Alvo: " + characters[target]

func _input(event: InputEvent) -> void:
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENSITIVITY * event.relative.x

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if Input.is_action_just_pressed("right_click"):
		shoot()

func _physics_process(_delta: float) -> void:	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if $"RayCast3D".is_colliding():
		$GUI/Crosshair.color = Color("#72ff56")
	else:
		$GUI/Crosshair.color = Color("#ffffff")
	
	global.points = points
	
	$GUI/Label3.text = "Tempo restante: " + str(int($Timer.time_left))
	
	position.x = clamp(position.x, -27.0, 27.0)
	position.z = clamp(position.z, -27.0, 27.0)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	const LEFT = Vector3()

	move_and_slide()

func restart():
	get_tree().reload_current_scene()
	
func shoot():
	if not $"RayCast3D".is_colliding():
		return
	if not $"RayCast3D".get_collider().has_method("kill"):
		return
	
	print("Target: " + str(target))
	print("Hit: " + str($"RayCast3D".get_collider().get_character()))
	if $"RayCast3D".get_collider().get_character() == target:
		points += 1
		target = randi_range(0, 5)
		$GUI/Label.text = "Alvo: " + $RayCast3D.get_collider().characters[target]
		$GUI/Label2.text = "Pontos: " + str(points)
		print("hi")
	else:
		points -= 1
		$GUI/Label2.text = "Pontos: " + str(points)
	
	$RayCast3D.get_collider().kill()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/timesup.tscn")
