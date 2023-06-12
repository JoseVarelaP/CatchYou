class STRNode:
	var pos: Vector2i
	var parent: STRNode
	var children: Array[STRNode]
	var heur: float
	var weight: int
	
	func _init( newpos: Vector2i, parent: STRNode = null ):
		self.pos = newpos
		self.parent = parent
		self.heur = 0
		self.children = []
		
		if(parent):
			self.weight = parent.weight + 1
		else:
			self.weight = 0
		
	func _to_string() -> String:
		return "(%d, %d)" % [pos.x, pos.y]
		
	func f_estrella(cur: Vector2i, goal: Vector2i):
		var res = self.weight + self.h_calc(cur, goal)
		return res
		
	# Calcula la distancia. Para esta ocasion, solamente detecta la distancia posible y mas cercana
	# al jugador, y aplica el valor. El que tenga menor valor, tendra mejor prioridad.
	func h_calc(cur: Vector2i, goal: Vector2i) -> float:
		var diff: Vector2 = cur - goal
		return diff.length()
		
	func expand(goal: Vector2i, franja: Array[STRNode]) -> void:
		var new_pos: STRNode = null
		var maxAreaTile: Vector2i = GlobalVars.getPositionTileFromMap( GlobalVars.areaForPlayer )
		
		for add in GlobalVars.PossibleLookoutLocations:
			var tempPosition: Vector2i = self.pos + add
			
            # Evita que el bloque a buscar se salga del mapa.
			if tempPosition.x < 0 or tempPosition.y < 0:
				continue
			
			if tempPosition.x > maxAreaTile.x or tempPosition.y > maxAreaTile.y:
				continue
			
			new_pos = STRNode.new( tempPosition, self )
			new_pos.heur = new_pos.h_calc( tempPosition, goal )
			self.children.append(new_pos)
			
		# Agrega los elementos generados a la franja, para ser analizados.
		for branch in self.children:
			if franja.is_empty():
				franja.append(branch)
			else:
				var pos = 0
				for node in franja:
					if node.heur > branch.heur:
						franja.insert(pos, branch)
						break
					pos += 1
	
	func search(goal: Vector2i, visits: Array[STRNode], franja: Array[STRNode]) -> PackedVector2Array:
		# Checa si ya esta en la meta.
		if goal == self.pos:
			var completedRoute: Array[Vector2] = []
			var globalPos = GlobalVars.int_mapTile.map_to_local(self.pos)
			completedRoute.append(globalPos)
			var parent = self.parent
			while parent:
				var pPos = GlobalVars.int_mapTile.map_to_local(parent.pos)
				completedRoute.append(pPos)
				parent = parent.parent
			#completedRoute.reverse()
			return PackedVector2Array(completedRoute)
			
		# Ok, no estamos en la meta, hay que seguir verificando.
		var visitedThisLocation: bool = false
		if not visits.is_empty():
			for visited in visits:
				if self.pos == visited.pos:
					# Ok, resulta si hemos visitado aqui.
					visitedThisLocation = true
					break
					
		if not visitedThisLocation:
			visits.append(self)
			self.expand(goal, franja)
			
		# Libera cualquier otro nodo posible en el mapa.
		if not franja.is_empty():
			return franja.pop_front().search(goal, visits, franja)
		
		return PackedVector2Array([])

func getPositionAsTile() -> Vector2i:
    return GlobalVars.getPositionTileFromMap(global_position)

func _process(delta: float):
    if not hasToMove:
        return
        
    # Si el jugador ha cambiado de posicion donde estaba la meta, vuelve a calcular.
    var pTilePos = GlobalVars.getPositionTileFromMap(GlobalVars.curPlayerPosition)
    if Vector2(pTilePos) != targetPosition and path.size() > 0:
        path.clear()
        
    if path.size() == 0:
        STR_Node = STRNode.new(getPositionAsTile())
        visits.clear()
        franjas.clear()
        path = STR_Node.search(pTilePos, visits, franjas)

func _physics_process(_delta: float) -> void:
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
            
    charFace.offset = velocity * .1
    move_and_slide()