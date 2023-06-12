func search(goal: Vector2i, visits: Dictionary, franja: Array[BPSNode]) -> PackedVector2Array:
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