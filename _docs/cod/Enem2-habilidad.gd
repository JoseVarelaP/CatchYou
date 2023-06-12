func getTransformedDifferenceToPlayer() -> Vector2:
	return transform.origin - GlobalVars.curPlayerTransform.origin

func _on_tiempo_exp_timeout():
	hasToExpand = true
	
	var diff = getTransformedDifferenceToPlayer()
	var direction = diff.normalized()
	
	if abs(direction.y) < 0.5:
		# El jugador esta izquierda/derecha.
		newSize = Vector2(1,2.0)
	else:
		# El jugador esta arriba/abajo.
		newSize = Vector2(2.0,1)
		
	shrinkTimer.start(3.0)

func _enemyNeedsToShrink():
	hasToExpand = false
	newSize = Vector2.ZERO