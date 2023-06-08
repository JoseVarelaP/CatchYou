extends Node2D

@export var ShakeStrength: float = 30.0
@export var ShakeDecay: float = 5.0
@export var enemySpeedFactor: float = 1

@onready var camera = $Jugador/Camera2D
@onready var gameMusic = $MusicStart
@onready var LoopMusic = $MusicLoop
@onready var highScoreSound = $"/root/GlobalAudio/highScoreSnd"
@onready var LvUpSound = $levelUp
@onready var animPlayer = $AnimationPlayer
@onready var tiempoLabel = $Interfaz/TiempoActual
@onready var speedCont = $Interfaz/speedFactor
@onready var speedLabel = $Interfaz/speedFactor/value
@onready var rand = RandomNumberGenerator.new()

@onready var skillTimer = $nextLevelTimer
@onready var BPMTimer = $BPMTimer

@onready var enemy = $Enem1

const BPM: float = 60.0/140.5
var curShakeStrength: float = 0.0

##
var curRhythmStrength: float = 0.0
var beatsUntilRave: int = 15
##

var tiempoTotal: float = 0.0
var lostGame: bool = false
var ogSpeedLabelPos: Vector2

var saveFile: saveFileManager = saveFileManager.new()
var Tiempo: TiempoCalc = TiempoCalc.new()
var UltimoTiempo: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand.randomize()
	UltimoTiempo = saveFile.loadfile()
	ogSpeedLabelPos = speedCont.position
	lostGame = true
	
	$Jugador.setAllowedToMove(false)
	$Enem1.setMove(false)
	
	animPlayer.play("readyAnim")
	
	await get_tree().create_timer(1.5).timeout
	
	beginGame()
	
func beginGame() -> void:
	lostGame = false
	gameMusic.play()
	skillTimer.start(10)
	BPMTimer.start(BPM)
	$Jugador.setAllowedToMove(true)
	$Enem1.setMove(true)
	
func applyShake() -> void:
	curShakeStrength = ShakeStrength
	
func getRandomCameraOffset() -> Vector2:
	return Vector2(
		rand.randf_range(-curShakeStrength, curShakeStrength),
		rand.randf_range(-curShakeStrength, curShakeStrength)
	)
	
func getPlayerTilePosition() -> Vector2i:
	var pos = $GridMap.local_to_map( $Jugador.global_position ) as Vector2i
	return pos
	
func actionLoseGame() -> void:
	# Marca el juego como terminado, para evitar que el jugador y los elementos sean
	# actualizados.
	lostGame = true
	gameMusic.stop()
	LoopMusic.stop()
	speedLabel.set_text( "[p align=center]%.2fx[/p]" % enemySpeedFactor )
	$Jugador.failPlayer()
	$Enem1.setMove(false)
	skillTimer.stop()
	BPMTimer.stop()
	applyShake()
	
	animPlayer.play("playerHitZoom")
	animPlayer.play("moveTimer")
	
	await get_tree().create_timer(1).timeout
	
	animPlayer.play("moveTimer")
	
	# Muestra la interfaz.
	$Interfaz/Perdiste.set_visible(true)
	$Interfaz/FondoPerdida.set_visible(true)
	
	if( tiempoTotal > UltimoTiempo ):
		animPlayer.play("highScoreShow")
		highScoreSound.play()
		# es un record!
	#saveFile.save(tiempoTotal, UltimoTiempo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if( curShakeStrength > 0.0 ):
		curShakeStrength = lerp(curShakeStrength, 0.0, ShakeDecay * delta)
		camera.offset = getRandomCameraOffset()
		speedCont.position = ogSpeedLabelPos + getRandomCameraOffset()
	
	if( curRhythmStrength > 0.0 ):
		curRhythmStrength = lerp(curRhythmStrength, 0.0, ShakeDecay * delta)
		speedCont.position = ogSpeedLabelPos + Vector2(0, -curRhythmStrength)
		
	if( lostGame ):
		return
	
	GlobalVars.areaForPlayer += Vector2(delta * 3.0, delta * 3.0)
	$ReferenceRect.set_size( GlobalVars.areaForPlayer )
	#var pos = getPlayerTilePosition()
	$Interfaz/speedFactor/ProgressBar.set_value( abs(10 - skillTimer.time_left) )
	#$Jugador/DBGPos.set_text( "%d,%d" % [pos.x,pos.y] )
		
	# Suma el tiempo actual a lo que esta.
	tiempoTotal += delta
	# Actualiza el tiempo total en la pantalla.
	tiempoLabel.set_text( Tiempo.ProcesaTiempo(tiempoTotal) )

func _on_area_2d_body_entered(body) -> void:
	if( body == $Jugador ):
		print_debug("[Actividad-Juego] Jugador - Colision con kill trigger")
		actionLoseGame()

func resetBoardSize() -> void:
	GlobalVars.areaForPlayer = Vector2(800.0,600.0)

func _on_reiniciar_button_up() -> void:
	# Recarga los elementos y reinicia la partida.
	resetBoardSize()
	get_tree().reload_current_scene()

func _on_salir_button_up() -> void:
	resetBoardSize()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_level_timer_timeout() -> void:
	LvUpSound.play()
	enemySpeedFactor += 0.2
	speedLabel.set_text( "[p align=center][wave amp=60.0 freq=8.0]%.2fx[/wave][/p]" % enemySpeedFactor )
	enemy.changeSpeed( enemySpeedFactor )

func _SongIntroFinished() -> void:
	LoopMusic.play()

func _CrossedBeat():
	if(beatsUntilRave > 0):
		beatsUntilRave -= 1
		print(beatsUntilRave)
	else:
		curRhythmStrength = 8.0
