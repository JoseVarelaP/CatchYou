"""
Enemigo 2

Simplemente realiza un calculo de normalización hacia la dirección del jugador.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE

### Ajustes ataque de enemigo
var hasToExpand: bool = false
var sizeSpeedDecay: float = 10
###

### Instancia actores
@onready var tExp: Timer = $TiempoExp
@onready var shrinkTimer: Timer = $timeBeforeShrink
@onready var charFace: Sprite2D = $face
###

var hasToMove = true

var ogSize: Vector2 = Vector2(0.5,0.5)
var extendSize: Vector2 = Vector2.ZERO
var newSize: Vector2 = Vector2.ZERO

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
	
	if( extendSize != newSize ):
		extendSize = lerp(extendSize, newSize, sizeSpeedDecay * delta)
		
	print(extendSize, newSize)
		
	$char.scale = ogSize + extendSize
	$Area2D/CollisionShape2D.scale = (ogSize + extendSize) * 1.5
	
	velocity = position.direction_to(GlobalVars.curPlayerPosition + Vector2(0,100.0)) * speed
	charFace.offset = velocity * .1
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVars.emit_signal("playerHit")

func _on_tiempo_exp_timeout():
	print("new timer")
	hasToExpand = true
	newSize = Vector2(1,2.0)
	shrinkTimer.start(3.0)
	pass # Replace with function body.


func _enemyNeedsToShrink():
	hasToExpand = false
	newSize = Vector2.ZERO
	pass # Replace with function body.
