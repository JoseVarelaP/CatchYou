class_name saveFileManager extends Node

func save( totalTime = 0, savedTime = 0 ):
	# Checa si la puntuación es mayor que lo que hay actualmente.
	if totalTime < savedTime:
		return
		
	var cfgFile = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	cfgFile.store_string("%s" % totalTime)
	cfgFile.close()

func load():
	if not FileAccess.file_exists("user://save_game.dat"):
		print("No se encontro el archivo, creando...")
		save(0)
		return 0
	var cfgFile = FileAccess.open("user://save_game.dat", FileAccess.READ)
	# print(cfgFile.get_as_text())
	var data = float(cfgFile.get_as_text())
	
	return data
