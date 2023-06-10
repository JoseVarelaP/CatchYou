"""
Enemigo 1

Simplemente realiza un calculo de normalización hacia la dirección del jugador.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE
@onready var charFace: Sprite2D = $face
var hasToMove = true

func _ready():
	$Area2D.connect("body_entered", _on_area_2d_body_entered)

func setMove(state : bool) -> void:
	hasToMove = state
	
func changeSpeed(level: float) -> void:
	speed = SPEED_BASE * level

func _physics_process(_delta) -> void:
	if not hasToMove:
		return
	
	velocity = position.direction_to(GlobalVars.curPlayerPosition) * speed
	charFace.offset = velocity * .1
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVars.emit_signal("playerHit")
