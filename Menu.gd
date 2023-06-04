extends Node2D

var mainGameScene : PackedScene

var saveFile = saveFileManager.new()
var Tiempo = TiempoCalc.new()

func _on_inicio_juego_button_up():
	print("[MainMenu] Cambiando escena")
	get_tree().change_scene_to_file("res://Juego.tscn")

func _on_salir_button_up():
	print("Saliendo")
	get_tree().quit()

func _on_tiempo_record_ready():
	var achievedScore = saveFile.loadfile()
	if achievedScore == null:
		return
		
	$TiempoRecord.set_text( Tiempo.ProcesaTiempo( achievedScore ) )
