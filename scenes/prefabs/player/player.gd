extends CharacterBody3D

@export var SPEED = 5.0
@export var MOUSE_SENSITIVITY = 0.5
var dead = false
var target
var points = 0
const char_heads = ["res://assets/png/Untitled_Artwork-26.png", "res://assets/png/Untitled_Artwork-8 4.png", "res://assets/png/Untitled_Artwork-32.png", "res://assets/png/Untitled_Artwork-20.png", "res://assets/png/Untitled_Artwork-2 5.png", "res://assets/png/Untitled_Artwork-14.png"]
@onready var test_icons = [$GUI/TextureRect2, $GUI/TextureRect3, $GUI/TextureRect4]
@onready var global = get_node("/root/Global")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	target = randi_range(0, 5)
	const characters = ["crianca_otaria", "dona_bernadette", "lucian", "mikhail", "yuu", "gilberto"]
	$GUI/TextureRect.texture = load(char_heads[target])

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
	
	if $"RayCast3D".is_colliding() and $"RayCast3D".get_collider() != null:
		$GUI/Crosshair.color = Color("#72ff56")
		$"RayCast3D".get_collider().outline = true
	else:
		$GUI/Crosshair.color = Color("#ffffff")
	
	global.points = points
	
	position.x = clamp(position.x, -27.0, 27.0)
	position.z = clamp(position.z, -27.0, 27.0)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	const LEFT = Vector3()
	
	$"GUI/Sprite-0001/TextureProgressBar".value = $Timer.time_left / $Timer.wait_time
	
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
		$GUI/Label4.visible = true
		test_icons[randi_range(0, 2)].visible = true
		$GUI/Timer.start(1)
		target = randi_range(0, 5)
		$GUI/TextureRect.texture = load(char_heads[target])
		$GUI/Label2.text = "Pontos: " + str(points)
		print("hi")
	else:
		points -= 1
		$GUI/Timer.start(0.5)
		$GUI/Label5.visible = true
		test_icons[0].visible = true
		$GUI/Label2.text = "Pontos: " + str(points)
	
	$RayCast3D.get_collider().kill()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/timesup.tscn")

func _on_point_timer_timeout() -> void:
	$GUI/Label4.visible = false
	$GUI/Label5.visible = false
	test_icons[0].visible = false
	test_icons[1].visible = false
	test_icons[2].visible = false
