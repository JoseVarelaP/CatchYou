func _ready() -> void:
	set_process(true)
	GlobalVars.curPlayerPosition = $Jugador.global_position
	GlobalVars.curPlayerTransform = $Jugador.transform
	GlobalVars.playerHit.connect(_onPlayerHit)
	GlobalVars.connectMap($GridMap)
	rand.randomize()
	UltimoTiempo = saveFile.loadfile()
	ogSpeedLabelPos = speedCont.position
	lostGame = true