extends Node2D
var tiempoTotal = 0
var lostGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Etiqueta-Tiempo
	pass # Replace with function body.
	
func ProcesaTiempo(sec):
	var seconds = int(sec)%60
	var minutes = (int(sec)/60)%60
	var hours = (int(sec)/60)/60
	
	if( sec >= 3600 ):
		return "%02d:%02d:%02d" % [hours, minutes, seconds]
	
	return "%02d:%02d" % [minutes, seconds]
	
func actionLoseGame():
	# Marca el juego como terminado, para evitar que el jugador y los elementos sean
	# actualizados.
	lostGame = true
	$Jugador.setAllowedToMove(false)
	
	# Muestra la interfaz.
	$"Interfaz-Perdiste".set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( lostGame ):
		return
		
	# Suma el tiempo actual a lo que esta.
	tiempoTotal += delta
	# Actualiza el tiempo total en la pantalla.
	$"TiempoActual".set_text( ProcesaTiempo(tiempoTotal) )

func _on_area_2d_body_entered(body):
	print("weeee")
	if( body == $Jugador ):
		actionLoseGame()


func _on_reiniciar_button_up():
	# Recarga los elementos y reinicia la partida.
	get_tree().reload_current_scene()

func _on_salir_button_up():
	get_tree().change_scene_to_file("res://main_menu.tscn")
