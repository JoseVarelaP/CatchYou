func getPositionTileFromMap( post: Vector2 ) -> Vector2i:
	var pos = int_mapTile.local_to_map( post ) as Vector2i
	return pos