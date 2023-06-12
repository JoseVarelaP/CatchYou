func actionLoseGame() -> void:
	# Marca el juego como terminado, para evitar que el jugador y los elementos sean
	# actualizados.
	lostGame = true
	gameMusic.stop()
	LoopMusic.stop()
	speedLabel.set_text( "[p align=center]%.2fx[/p]" % enemySpeedFactor )
	$Jugador.failPlayer()
	for e in enemies:
		e.setMove(false)
	$Interfaz/Listo.set_visible(false)
	skillTimer.stop()
	BPMTimer.stop()
	$Interfaz/HighScorePanel.set_visible(false)
	applyShake()
	
	animPlayer.play("playerHitZoom")
	animPlayer.play("moveTimer")
	
	await get_tree().create_timer(1).timeout
	
	# Muestra la interfaz.
	$Interfaz/Perdiste.set_visible(true)
	$Interfaz/FondoPerdida.set_visible(true)
	
	if( tiempoTotal > UltimoTiempo ):
		animPlayer.play("highScoreShow")
		highScoreSound.play()
		# es un record!
		saveFile.save(tiempoTotal, UltimoTiempo)

func _onPlayerHit() -> void:
	actionLoseGame()