extends CharacterBody2D

var SPEED: float = 300.0
const accel: float = 1500
const friction: int = 600
@export var boostDecay: float = 5.0
var speedDelta: Vector2 = Vector2(0.0,0.0)

signal boostStatusChanged( status )

@onready var hitSound: AudioStreamPlayer = $hitPlayer
@onready var particles: GPUParticles2D = $Particles
@onready var bgPartc: GPUParticles2D = $BackgroundParticle
@onready var charFace: Sprite2D = $CollisionShape2D/face

var boostEnabled: bool = false
const border_margin: float = 30
var allowedToMove: bool = true

var curBoostSpeed: float = 1.0

var hurtFaceTex = preload("res://img/char-hit.svg");

func setAllowedToMove(state : bool) -> void:
	allowedToMove = state
		
func failPlayer() -> void:
	setAllowedToMove(false)
	hitSound.play()
	particles.set_emitting(false)
	bgPartc.set_emitting(false)
	$"boost-loop".stop()
	$"boost-init".stop()
	charFace.set_texture(hurtFaceTex)
	
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
		
	if( curBoostSpeed > 1 ):
		curBoostSpeed = lerp(curBoostSpeed, 1.0, boostDecay * delta)
		SPEED = lerp(SPEED, 300.0, boostDecay * delta)

	input = getInputMovement()
	
	var curBoostBtn = Input.is_action_pressed("char_boost")
	
	if( curBoostBtn != boostEnabled ):
		boostEnabled = curBoostBtn
		if( curBoostBtn ):
			boostStatusChanged.emit(true)
			$"boost-init".play()
			$"boost-loop".play()
		else:
			boostStatusChanged.emit(false)
			$"boost-loop".stop()
			
	if( Input.is_action_pressed("char_boost") ):
		SPEED = 600
		curBoostSpeed = 4.0
		
	print(boostEnabled)
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * curBoostSpeed * delta)
		velocity = velocity.limit_length(SPEED)
		
	charFace.offset = velocity * .1
		
	particles.get_process_material().set_gravity(
		Vector3( -velocity.x , -velocity.y ,0)
	)

	# Declara limites de posición para que no se salga de la pantalla.
	CheckBoundries()
	
	move_and_slide()
