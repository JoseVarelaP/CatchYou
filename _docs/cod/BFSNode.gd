class BFSNode:
	var pos: Vector2i
	var children: Array[BFSNode]
	var parent: BFSNode
	var visited: bool = false
	
	func _init(pos: Vector2i, parent: BFSNode = null):
		self.pos = pos
		self.parent = parent
		self.children = []
		
	func _to_string() -> String:
		return "(%d, %d)" % [pos.x, pos.y]
		
	func expand(goal: Vector2i, franja: Array[BFSNode]) -> void:
		var new_pos: BFSNode = null
		var maxAreaTile: Vector2i = GlobalVars.getPositionTileFromMap( GlobalVars.areaForPlayer )
		var pTilePos = GlobalVars.getPositionTileFromMap(GlobalVars.curPlayerPosition)
		
		for add in GlobalVars.PossibleLookoutLocations:
			var tempPosition: Vector2i = self.pos + add
			
			if tempPosition.x < 0 or tempPosition.x < pTilePos.x-distanceMargin.x \
			or tempPosition.y < 0 or tempPosition.y < pTilePos.y-distanceMargin.y:
				continue
			
			if tempPosition.x > maxAreaTile.x or tempPosition.x > pTilePos.x+distanceMargin.x \
			or tempPosition.y > maxAreaTile.y or tempPosition.y > pTilePos.y+distanceMargin.y:
				continue
			
			new_pos = BFSNode.new( tempPosition, self )
			self.children.append(new_pos)
			
		# Agrega los elementos generados a la franja, para ser analizados.
		for branch in self.children:
			franja.append(branch)
	
	func search(goal: Vector2i, visits: Dictionary, franja: Array[BFSNode]) -> PackedVector2Array:
		var stack = []
		stack.append(self)
		while len(stack) != 0:
			# Libera cualquier otro nodo posible en el mapa.
			var current = stack.pop_front()
			# Checa si ya esta en la meta.
			if goal == current.pos:
				var completedRoute: Array[Vector2] = []
				var globalPos = GlobalVars.int_mapTile.map_to_local(current.pos)
				completedRoute.append(globalPos)
				var parent = current.parent
				while parent:
					var pPos = GlobalVars.int_mapTile.map_to_local(parent.pos)
					completedRoute.append(pPos)
					parent = parent.parent
				#completedRoute.reverse()
				return PackedVector2Array(completedRoute)
				
			var locString = JSON.stringify(current.pos)
			if not visits.has(locString):
				visits[locString] = true
				current.expand(goal, franja)
				
			for n in current.children:
				stack.append(n)
		
		return PackedVector2Array([])

func _process(delta: float) -> void:
	if not hasToMove:
		return
	# Si el jugador ha cambiado de posicion donde estaba la meta, vuelve a calcular.
	var pTilePos = GlobalVars.getPositionTileFromMap(GlobalVars.curPlayerPosition)
	if Vector2(pTilePos) != targetPosition and path.size() > 0:
		path.clear()
		
	if path.size() == 0:
		BFS_Root = BFSNode.new(getPositionAsTile())
		visits.clear()
		franjas.clear()
		path = BFS_Root.search(pTilePos, visits, franjas)

func _physics_process(delta: float) -> void:
	if not hasToMove:
		return

	# Reinicia la velocidad.
	velocity = Vector2.ZERO
	
	if path.size() > 0 :
		var posMove: Vector2 = path[0]
		var distance = position.distance_to(posMove)
		if (distance>1):
			targetPosition = posMove
			velocity = position.direction_to(posMove) * speed
		else:
			path.remove_at(0)
	
	if( speedScale != newSpeedExtra ):
		speedScale = lerp(speedScale, newSpeedExtra, sizeSpeedDecay * delta)
		
	#print(speedScale, newSpeedExtra)
		
	speed = SPEED_BASE + speedScale
	
	#targetPosition = GlobalVars.curPlayerPosition
	#velocity = position.direction_to(GlobalVars.curPlayerPosition) * speed
	if( speedScale > 0 ):
		boostPart.get_process_material().set_gravity(
			Vector3( -velocity.x , -velocity.y ,0)
		)
	charFace.offset = velocity * .1
	move_and_slide()

# Al momento que el temporizador termine, este comenzara la aceleracion del
# oponente.
func _on_tiempo_exp_timeout():
	hasToExpand = true
	newSpeedExtra = charBoostSpeed
	boostPart.set_emitting(true)
	# Comienza un temporizador de 3 segundos para detener el cohete del oponente.
	shrinkTimer.start(3.0)
	pass # Replace with function body.

# Llamado cuando el temporizador shrink termina, para detener el cohete.
func _enemyNeedsToShrink():
	hasToExpand = false
	boostPart.set_emitting(false)
	newSpeedExtra = 0.0
	pass # Replace with function body.