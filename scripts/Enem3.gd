"""
Enemigo 3

Simplemente realiza un calculo de normalización hacia la dirección del jugador.

Este enemigo tiene la habilidad de ir rápido por unos segundos.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE
# Que tan rapido vamos a acelerar al oponente sumando a SPEED_BASE.
var charBoostSpeed: float = 200.0

### Ajustes ataque de enemigo
var hasToExpand: bool = false
var sizeSpeedDecay: float = 10
###

### Instancia actores
@onready var tExp: Timer = $TiempoExp
@onready var shrinkTimer: Timer = $timeBeforeShrink
@onready var charFace: Sprite2D = $face
@onready var boostPart: GPUParticles2D = $boost
###

@export var path: PackedVector2Array
@export var targetPosition: Vector2 = Vector2(0.0,0.0)

var hasToMove = true

var speedScale: float = 0.0
var newSpeedExtra: float = 0.0

func _ready():
	$Area2D.connect("body_entered", _on_area_2d_body_entered)

func setMove(state : bool) -> void:
	hasToMove = state
	if(state):
		tExp.start(10.0)
	
func changeSpeed(level: float) -> void:
	speed = SPEED_BASE * level

func _physics_process(delta: float) -> void:
	if not hasToMove:
		return
	
	if( speedScale != newSpeedExtra ):
		speedScale = lerp(speedScale, newSpeedExtra, sizeSpeedDecay * delta)
		
	#print(speedScale, newSpeedExtra)
		
	speed = SPEED_BASE + speedScale
	
	targetPosition = GlobalVars.curPlayerPosition
	velocity = position.direction_to(GlobalVars.curPlayerPosition) * speed
	if( speedScale > 0 ):
		boostPart.get_process_material().set_gravity(
			Vector3( -velocity.x , -velocity.y ,0)
		)
	charFace.offset = velocity * .1
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVars.emit_signal("playerHit")

func _on_tiempo_exp_timeout():
	hasToExpand = true
	newSpeedExtra = charBoostSpeed
	boostPart.set_emitting(true)
	shrinkTimer.start(3.0)
	pass # Replace with function body.


func _enemyNeedsToShrink():
	hasToExpand = false
	boostPart.set_emitting(false)
	newSpeedExtra = 0.0
	pass # Replace with function body.
