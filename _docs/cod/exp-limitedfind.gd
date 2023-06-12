const distanceMargin: Vector2i = Vector2i(15,15)

for add in GlobalVars.PossibleLookoutLocations:
	var tempPosition: Vector2i = self.pos + add
	
	if tempPosition.x < 0 or tempPosition.x < pTilePos.x-distanceMargin.x \
	or tempPosition.y < 0 or tempPosition.y < pTilePos.y-distanceMargin.y:
		continue
	
	if tempPosition.x > maxAreaTile.x or tempPosition.x > pTilePos.x+distanceMargin.x \
	or tempPosition.y > maxAreaTile.y or tempPosition.y > pTilePos.y+distanceMargin.y:
		continue
	
	new_pos = DFSNode.new( tempPosition, self )
	self.children.append(new_pos)
	