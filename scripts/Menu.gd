extends Node2D

var mainGameScene : PackedScene

var saveFile: saveFileManager = saveFileManager.new()
var Tiempo: TiempoCalc = TiempoCalc.new()

func _ready():
	$anims.play("MenuTransitions/transitionIn")
	get_viewport().connect("size_changed", _on_screen_resized)
	_on_screen_resized()
	$Version.set_text( "Version %s" % [GlobalVars.GameVersion] )

func _on_inicio_juego_button_up() -> void:
	$anims.play("MenuTransitions/transitionOut")
	await get_tree().create_timer(1).timeout
	
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

func _on_salir_pressed():
	_on_salir_button_up()

func _on_acerca_button_up():
	$anims.play("MenuTransitions/transitionOut")
	await get_tree().create_timer(1).timeout
	
	print_debug("[MainMenu] Cambiando escena")
	get_tree().change_scene_to_file("res://scenes/Acerca.tscn")
	
# Ajuste dinamico de ventana.
func _on_screen_resized():
	var windowsize: Vector2 = get_viewport_rect().size
	print(windowsize*.5)
	$PanelContainer.position = Vector2(
		windowsize.x*.5 - 400,
		windowsize.y*.5 - 300,
	)
	$InfoCR.position = Vector2(
		windowsize.x - 160,
		windowsize.y - 40,
	)
	$Version.position = Vector2(
		20,
		windowsize.y - 40,
	)
