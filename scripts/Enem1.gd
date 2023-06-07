"""
Enemigo 1

Simplemente realiza un calculo de normalización hacia la dirección del jugador.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE
@onready var p = $"../Jugador"
var hasToMove = true

func setMove(state : bool) -> void:
	hasToMove = state
	
func changeSpeed(level: float) -> void:
	speed = SPEED_BASE * level

func _physics_process(_delta) -> void:
	if not hasToMove:
		return
	
	velocity = position.direction_to(p.position) * speed
	move_and_slide()
