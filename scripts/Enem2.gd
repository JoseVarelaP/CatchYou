"""
Enemigo 2

Este enemigo crea una barricada durante un tiempo ha ocurrido.
El objetivo aqui es hacer que este mismo esté en frente del jugador, y
genere la barricada.

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
@export var targetPosition: Vector2 = Vector2(0.0,0.0)
###

var hasToMove = true

var ogSize: Vector2 = Vector2(0.5,0.5)
var extendSize: Vector2 = Vector2.ZERO
var newSize: Vector2 = Vector2.ZERO

##########
@export var path: PackedVector2Array
const PossibleLocations = [
	Vector2i.LEFT,
	Vector2i(-1,-1),
	Vector2i(0,-1),
	Vector2i(1,-1),
	Vector2i(1,-0),
	Vector2i(1,1),
	Vector2i(0,1),
	Vector2i(-1,-0),
]
		
##########

func _ready():
	$Area2D.connect("body_entered", _on_area_2d_body_entered)

func setMove(state : bool) -> void:
	hasToMove = state
	if(state):
		#BFS_Root = BFSNode.new(GlobalVars.getPositionTileFromMap(position))
		#BFS_Root.expand(BFS_Franja)
		tExp.start(10.0)
	
func changeSpeed(level: float) -> void:
	speed = SPEED_BASE * level
	
func getTransformedDifferenceToPlayer() -> Vector2:
	return transform.origin - GlobalVars.curPlayerTransform.origin

func _physics_process(delta: float) -> void:
	if not hasToMove:
		return
	
	if( extendSize != newSize ):
		extendSize = lerp(extendSize, newSize, sizeSpeedDecay * delta)
		
	#print(extendSize, newSize)
		
	$char.scale = ogSize + extendSize
	$enemyBlock.scale = (ogSize + extendSize) * 1.5
	$Area2D/CollisionShape2D.scale = (ogSize + extendSize) * 1.5
	
	# Si el bloque está extendido, que se quede ahí.
	if( hasToExpand ):
		velocity = Vector2.ZERO
		charFace.offset = Vector2.ZERO
		return;
	
	# Obten la posición normalizada en X del oponente basada en el jugador.
	var diff = getTransformedDifferenceToPlayer()
	var direction = diff.normalized()
	var distance = diff.length()
	
	# print(direction, distance)
	
	var tmpTarget: Vector2 = Vector2(GlobalVars.curPlayerPosition)
	if distance > 300:
		#print("left side")
		speed = SPEED_BASE
		tmpTarget += direction*200
	else:
		speed = 200
		tmpTarget += direction*200
	
	targetPosition = tmpTarget
	velocity = position.direction_to(targetPosition) * speed
	
	charFace.offset = velocity * .1
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVars.emit_signal("playerHit")

func _on_tiempo_exp_timeout():
	hasToExpand = true
	
	var diff = getTransformedDifferenceToPlayer()
	var direction = diff.normalized()
	
	if abs(direction.y) < 0.5:
		# El jugador está izquierda/derecha.
		newSize = Vector2(1,2.0)
	else:
		# El jugador está arriba/abajo.
		newSize = Vector2(2.0,1)
		
	shrinkTimer.start(3.0)
	pass # Replace with function body.


func _enemyNeedsToShrink():
	hasToExpand = false
	newSize = Vector2.ZERO
	pass # Replace with function body.
