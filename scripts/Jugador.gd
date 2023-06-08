extends CharacterBody2D

const SPEED: float = 300.0
const accel: float = 1500
const friction: int = 600
var speedDelta: Vector2 = Vector2(0.0,0.0)

@onready var hitSound: AudioStreamPlayer = $hitPlayer
@onready var particles: GPUParticles2D = $Particles
@onready var bgPartc: GPUParticles2D = $BackgroundParticle

const border_margin: float = 30
var allowedToMove = true

func setAllowedToMove(state : bool) -> void:
	allowedToMove = state
		
func failPlayer() -> void:
	setAllowedToMove(false)
	hitSound.play()
	particles.set_emitting(false)
	bgPartc.set_emitting(false)
	
func setRave(state: bool) -> void:
	particles.set_emitting(state)
	bgPartc.set_emitting(state)
	
func CheckBoundries() -> void:
	# Declara limites de posición para que no se salga de la pantalla.
	if position.x < border_margin:
		position.x = border_margin
	if position.y < border_margin:
		position.y = border_margin
	if position.x > GlobalVars.areaForPlayer.x - border_margin:
		position.x = GlobalVars.areaForPlayer.x - border_margin
	if position.y > GlobalVars.areaForPlayer.y - border_margin:
		position.y = GlobalVars.areaForPlayer.y - border_margin

var input: Vector2 = Vector2(0,0)
func getInputMovement() -> Vector2:
	var vecVel = Input.get_vector("move_left", "move_right", "move_up", "move_down") as Vector2
	return vecVel.normalized()
		
func _physics_process(delta: float):
	if( not allowedToMove ):
		return

	input = getInputMovement()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(SPEED)
		
	particles.get_process_material().set_gravity(
		Vector3( -velocity.x , -velocity.y ,0)
	)

	# Declara limites de posición para que no se salga de la pantalla.
	CheckBoundries()
	
	move_and_slide()
