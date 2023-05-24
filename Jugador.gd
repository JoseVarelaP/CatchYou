extends CharacterBody2D

const SPEED = 300.0
var speedDelta = {"y": 0.0, "x": 0.0}

var width_area = ProjectSettings.get_setting("display/window/size/viewport_width")
var height_area = ProjectSettings.get_setting("display/window/size/viewport_height")
const border_margin = 30
const speedSlowdownForPlayer = 350
var allowedToMove = true

func setAllowedToMove(state):
	allowedToMove = state
	
func CheckBoundries():
	# Declara limites de posición para que no se salga de la pantalla.
	if position.x < border_margin:
		position.x = border_margin
	if position.y < border_margin:
		position.y = border_margin
	if position.x > width_area - border_margin:
		position.x = width_area - border_margin
	if position.y > height_area - border_margin:
		position.y = height_area - border_margin

var lastPos = [0,0]
func _physics_process(delta):
	if( not allowedToMove ):
		return	
	
	var vertdir = Input.get_axis("ui_up", "ui_down")
	if vertdir:
		lastPos[1] = vertdir
		speedDelta.y += 10
		if speedDelta.y > SPEED:
			speedDelta.y = SPEED
		velocity.y = vertdir * speedDelta.y
	else:
		velocity.y = move_toward(velocity.y, 0, speedDelta.y)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		lastPos[0] = direction
		speedDelta.x += 10
		if speedDelta.x > SPEED:
			speedDelta.x = SPEED
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, speedDelta.x)
		
	# Ralentiza el jugador cuando no oprima botones.
	if speedDelta.x > 0:
		velocity.x = speedDelta.x * lastPos[0]
		speedDelta.x -= delta * speedSlowdownForPlayer
	else:
		velocity.x = 0
		
	if speedDelta.y > 0:
		velocity.y = speedDelta.y * lastPos[1]
		speedDelta.y -= delta * speedSlowdownForPlayer
	else:
		velocity.y = 0

	# Declara limites de posición para que no se salga de la pantalla.
	CheckBoundries()
	
	move_and_slide()
