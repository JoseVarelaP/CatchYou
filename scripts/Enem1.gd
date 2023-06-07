"""
Enemigo 1

Simplemente realiza un calculo de normalización hacia la dirección del jugador.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE
@onready var p = $"../Jugador"
var hasToMove = true

func setMove(state : bool):
	hasToMove = state
	
func changeSpeed(level: float):
	speed = SPEED_BASE * level

func _physics_process(_delta):
	if not hasToMove:
		return
	
	velocity = position.direction_to(p.position) * speed
	move_and_slide()
