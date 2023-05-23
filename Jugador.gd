extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const width_area = 800
const height_area = 600
const border_margin = 30

var allowedToMove = true

func setAllowedToMove(state):
	allowedToMove = state

func _physics_process(delta):
	if( not allowedToMove ):
		return
		
	# Add the gravity.
	"""
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	"""
	
	var vertdir = Input.get_axis("ui_up", "ui_down")
	if vertdir:
		velocity.y = vertdir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if position.x < border_margin:
		position.x = border_margin
	if position.y < border_margin:
		position.y = border_margin
	if position.x > width_area - border_margin:
		position.x = width_area - border_margin
	if position.y > height_area - border_margin:
		position.y = height_area - border_margin
	
	move_and_slide()
