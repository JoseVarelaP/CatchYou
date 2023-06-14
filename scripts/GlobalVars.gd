extends Node

@export var areaForPlayer: Vector2 = Vector2(800.0,600.0)
@export var curPlayerPosition: Vector2 = Vector2(0.0,0.0)
@export var curPlayerTransform: Transform2D

@export var int_mapTile: TileMap

const PossibleLookoutLocations = [
	Vector2i.LEFT,
	#Vector2i(-1,-1),
	Vector2i.UP,
	#Vector2i(1,-1),
	Vector2i.RIGHT,
	#Vector2i(1,1),
	Vector2i.DOWN,
	#Vector2i(-1,-0),
]

func _ready():
	print("uhie")

func getPlayerPositionFromMap( Jugador: CharacterBody2D ) -> Vector2i:
	var pos = int_mapTile.local_to_map( Jugador.global_position ) as Vector2i
	return pos
	
func getPositionTileFromMap( post: Vector2 ) -> Vector2i:
	var pos = int_mapTile.local_to_map( post ) as Vector2i
	return pos
	
func connectMap( Map: TileMap ) -> bool:
	if not (Map is TileMap):
		return false
		
	int_mapTile = Map
	return true

signal windowResize
signal playerHit
