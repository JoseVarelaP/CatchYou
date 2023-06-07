class_name saveFileManager extends Node

func save( totalTime: float = 0.0, savedTime: float = 0.0 ):
	# Checa si la puntuación es mayor que lo que hay actualmente.
	if totalTime < savedTime:
		return
		
	var cfgFile = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	cfgFile.store_string("%s" % totalTime)
	cfgFile.close()

func loadfile() -> float:
	if not FileAccess.file_exists("user://save_game.dat"):
		print_debug("No se encontro el archivo, creando...")
		save(0)
		return 0
	var cfgFile = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var data = float(cfgFile.get_as_text())
	
	return data
