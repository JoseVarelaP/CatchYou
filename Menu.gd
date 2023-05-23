extends Node2D

var mainGameScene : PackedScene

func _on_inicio_juego_button_up():
	print("Cambiando escena")
	get_tree().change_scene_to_file("res://Juego.tscn")


func _on_salir_button_up():
	print("Saliendo")
	get_tree().quit()
