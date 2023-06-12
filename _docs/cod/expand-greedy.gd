func expand(goal: Vector2i, franja: Array[GRNode]) -> void:
	var new_pos: GRNode = null
	var maxAreaTile: Vector2i = GlobalVars.getPositionTileFromMap( GlobalVars.areaForPlayer )
	
	for add in GlobalVars.PossibleLookoutLocations:
		var tempPosition: Vector2i = self.pos + add
		
		if tempPosition.x < 0 or tempPosition.y < 0:
			continue
		
		if tempPosition.x > maxAreaTile.x or tempPosition.y > maxAreaTile.y:
			continue
		
		new_pos = GRNode.new( tempPosition, self )
		new_pos.h = new_pos.h_calc(tempPosition, goal)
		self.children.append(new_pos)
		
	# Agrega los elementos generados a la franja, para ser analizados.
	for branch in self.children:
		if franja.is_empty():
			franja.append(branch)
		else:
			var pos = 0
			for node in franja:
				if node.h > branch.h:
					franja.insert(pos, branch)
					break
				pos += 1