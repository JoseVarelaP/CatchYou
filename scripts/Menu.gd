extends Node2D

var mainGameScene : PackedScene

var saveFile: saveFileManager = saveFileManager.new()
var Tiempo: TiempoCalc = TiempoCalc.new()

func _on_inicio_juego_button_up() -> void:
	print_debug("[MainMenu] Cambiando escena")
	get_tree().change_scene_to_file("res://scenes/Juego.tscn")

func _on_salir_button_up() -> void:
	print_debug("Saliendo")
	get_tree().quit()

func _on_tiempo_record_ready() -> void:
	var achievedScore = saveFile.loadfile()
	if achievedScore == null:
		return
		
	$TiempoRecord.set_text( Tiempo.ProcesaTiempo( achievedScore ) )

func _on_inicio_juego_pressed() -> void:
	_on_inicio_juego_button_up()
