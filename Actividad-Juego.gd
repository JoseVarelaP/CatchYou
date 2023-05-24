extends Node2D
var tiempoTotal = 0
var lostGame = false

var saveFile = saveFileManager.new()
var Tiempo = TiempoCalc.new()
var UltimoTiempo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	UltimoTiempo = saveFile.load()
	pass # Replace with function body.
	
func actionLoseGame():
	# Marca el juego como terminado, para evitar que el jugador y los elementos sean
	# actualizados.
	lostGame = true
	$Jugador.setAllowedToMove(false)
	
	# Muestra la interfaz.
	$Interfaz/Perdiste.set_visible(true)
	$FondoPerdida.set_visible(true)
	
	saveFile.save(tiempoTotal, UltimoTiempo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( lostGame ):
		return
		
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
