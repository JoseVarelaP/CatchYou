"""
Enemigo 2

Este enemigo crea una barricada durante un tiempo ha ocurrido.
El objetivo aqui es hacer que este mismo esté en frente del jugador, y
genere la barricada.

Este enemigo implementa el algoritmo Greedy.
"""

extends CharacterBody2D

const SPEED_BASE = 80
var speed = SPEED_BASE

### Ajustes ataque de enemigo
var hasToExpand: bool = false
var sizeSpeedDecay: float = 10
###

### Instancia actores
@onready var tExp: Timer = $TiempoExp
@onready var shrinkTimer: Timer = $timeBeforeShrink
@onready var charFace: Sprite2D = $face
@export var targetPosition: Vector2 = Vector2(0.0,0.0)
###

var hasToMove = true

var ogSize: Vector2 = Vector2(0.5,0.5)
var extendSize: Vector2 = Vector2.ZERO
var newSize: Vector2 = Vector2.ZERO

##########
@export var path: PackedVector2Array
var direction: Vector2 = Vector2(0,0)

@onready var visits : Array[GRNode] = []
@onready var franjas : Array[GRNode] = []
var GR_Root: GRNode = null
##########

class GRNode:
	var pos: Vector2i
	var children: Array[GRNode]
	var parent: GRNode
	var h: float
	
	func _init(pos: Vector2i, parent: GRNode = null):
		self.pos = pos
		self.parent = parent
		self.children = []
		
	func _to_string() -> String:
		return "(%d, %d)" % [pos.x, pos.y]
		
	# Calcula la distancia. Para esta ocasión, solamente detecta la distancia posible y más cercana
	# al jugador, y aplica el valor. El que tenga menor valor, tendrá mejor prioridad.
	func h_calc(cur: Vector2i, goal: Vector2i) -> float:
		var diff: Vector2 = cur - goal
		return diff.length()
		
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
			
	func search(goal: Vector2i, visits: Array[GRNode], franja: Array[GRNode]) -> PackedVector2Array:
		# Checa si ya está en la meta.
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
		
func _ready():
	$Area2D.connect("body_entered", _on_area_2d_body_entered)

func setMove(state : bool) -> void:
	hasToMove = state
	if(state):
		tExp.start(10.0)
	
func changeSpeed(level: float) -> void:
	speed = SPEED_BASE * level
	
func getTransformedDifferenceToPlayer() -> Vector2:
	return transform.origin - GlobalVars.curPlayerTransform.origin

func _process(delta: float) -> void:
	if not hasToMove:
		return
		
	# Si el jugador ha cambiado de posición donde estaba la meta, vuelve a calcular.
	var pTilePos = GlobalVars.getPositionTileFromMap(GlobalVars.curPlayerPosition)
	if Vector2(pTilePos) != targetPosition and path.size() > 0:
		path.clear()
		
	if path.size() == 0:
		GR_Root = GRNode.new(getPositionAsTile())
		visits.clear()
		franjas.clear()
		path = GR_Root.search(pTilePos, visits, franjas)

func _physics_process(delta: float) -> void:
	if not hasToMove:
		return
	
	if( extendSize != newSize ):
		extendSize = lerp(extendSize, newSize, sizeSpeedDecay * delta)
		
	#print(extendSize, newSize)
		
	$char.scale = ogSize + extendSize
	$enemyBlock.scale = (ogSize + extendSize) * 1.5
	$Area2D/CollisionShape2D.scale = (ogSize + extendSize) * 1.5
	
	# Si el bloque está extendido, que se quede ahí.
	if( hasToExpand ):
		velocity = Vector2.ZERO
		charFace.offset = Vector2.ZERO
		return;
		
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
	
	"""
	# Obten la posición normalizada en X del oponente basada en el jugador.
	var diff = getTransformedDifferenceToPlayer()
	var direction = diff.normalized()
	var distance = diff.length()
	
	# print(direction, distance)
	
	var tmpTarget: Vector2 = Vector2(GlobalVars.curPlayerPosition)
	if distance > 300:
		#print("left side")
		speed = SPEED_BASE
		tmpTarget += direction*200
	else:
		speed = 200
		tmpTarget += direction*200
	
	targetPosition = tmpTarget
	velocity = position.direction_to(targetPosition) * speed
	
	charFace.offset = velocity * .1
	move_and_slide()
	"""
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVars.emit_signal("playerHit")

func _on_tiempo_exp_timeout():
	hasToExpand = true
	
	var diff = getTransformedDifferenceToPlayer()
	var direction = diff.normalized()
	
	if abs(direction.y) < 0.5:
		# El jugador está izquierda/derecha.
		newSize = Vector2(1,2.0)
	else:
		# El jugador está arriba/abajo.
		newSize = Vector2(2.0,1)
		
	shrinkTimer.start(3.0)
	pass # Replace with function body.


func _enemyNeedsToShrink():
	hasToExpand = false
	newSize = Vector2.ZERO
	pass # Replace with function body.
