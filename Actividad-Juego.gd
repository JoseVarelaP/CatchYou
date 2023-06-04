extends Node2D
var tiempoTotal = 0
var lostGame = false

var saveFile = saveFileManager.new()
var Tiempo = TiempoCalc.new()
var UltimoTiempo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	UltimoTiempo = saveFile.loadfile()
	
func getPlayerTilePosition() -> Vector2i:
	var pos = $GridMap.local_to_map( $Jugador.global_position ) as Vector2i
	return pos
	
func actionLoseGame():
	# Marca el juego como terminado, para evitar que el jugador y los elementos sean
	# actualizados.
	lostGame = true
	$Jugador.setAllowedToMove(false)
	$Enem1.setMove(false)
	
	# Muestra la interfaz.
	$Interfaz/Perdiste.set_visible(true)
	$Interfaz/FondoPerdida.set_visible(true)
	
	saveFile.save(tiempoTotal, UltimoTiempo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( lostGame ):
		return
		
	var pos = getPlayerTilePosition()
	$Jugador/DBGPos.set_text( "%d,%d" % [pos.x,pos.y] )
		
	# Suma el tiempo actual a lo que esta.
	tiempoTotal += delta
	# Actualiza el tiempo total en la pantalla.
	$Interfaz/TiempoActual.set_text( Tiempo.ProcesaTiempo(tiempoTotal) )

func _on_area_2d_body_entered(body):
	print("[Actividad-Juego] Jugador - Colision con kill trigger")
	if( body == $Jugador ):
		actionLoseGame()

func _on_reiniciar_button_up():
	# Recarga los elementos y reinicia la partida.
	get_tree().reload_current_scene()

func _on_salir_button_up():
	get_tree().change_scene_to_file("res://main_menu.tscn")
