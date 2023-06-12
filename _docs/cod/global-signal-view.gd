func connectMap( Map: TileMap ) -> bool:
	if not (Map is TileMap):
		return false
		
	int_mapTile = Map
	return true

signal playerHit
