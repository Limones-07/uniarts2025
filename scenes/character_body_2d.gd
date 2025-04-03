extends CharacterBody2D

const SPEED = 50.0
var anim
var animSprite

func _ready() -> void:
	anim = $AnimatedSprite2D/AnimationPlayer
	animSprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX := Input.get_axis("ui_left", "ui_right")
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if directionX == 1:
		animSprite.flip_h = false
	elif directionX == -1:
		animSprite.flip_h = true
	
	var directionY := Input.get_axis("ui_up", "ui_down")
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity != Vector2.ZERO:
		anim.play("walk")
	else:
		anim.play("RESET")
	
	move_and_slide()
