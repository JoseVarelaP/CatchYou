"""
Enemigo 1

Simplemente realiza un calculo de normalización hacia la dirección del jugador.
"""

extends CharacterBody2D

var speed = 80
@onready var p = $"../Jugador"
var hasToMove = true

func setMove(state : bool):
	hasToMove = state

func _physics_process(_delta):
	if not hasToMove:
		return
	
	velocity = position.direction_to(p.position) * speed
	move_and_slide()
