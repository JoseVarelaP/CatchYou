extends Node

var save_data = {
	"score": 0,
	"name": "NAME"
}


func save():
	var cfgFile = File.new()
	cfgFile.open("user://save.cfg", File.WRITE)
	cfgFile.store_line(to_json(save_data))
	cfgFile.close()

func load():
	var cfgFile = File.new()
	if not cfgFile.fileExists("user://save.cfg", File.READ)
		save()
		return
	cfgFile.open("user://save.cfg", File.READ)
	var data = parse_json(cfgFile.get_as_text())

	save_data.score = data.score
	save_data.name = data.name
