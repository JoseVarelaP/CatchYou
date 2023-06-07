class_name TiempoCalc

func ProcesaTiempo(sec) -> String:
	var seconds: int = int(sec)%60
	var minutes: int = (int(sec)/60)%60
	var hours: int = (int(sec)/60)/60
	var milisec: int = int(sec*1000) % 1000
	
	if( sec >= 3600 ):
		return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milisec]
	
	return "%02d:%02d.%03d" % [minutes, seconds, milisec]
