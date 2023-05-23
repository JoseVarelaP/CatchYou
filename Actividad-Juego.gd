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
		lostGame = true
		$Jugador.setAllowedToMove(false)
