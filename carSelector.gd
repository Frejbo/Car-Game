extends OptionButton

const carScenes : Array[String] = ["res://car.tscn", "res://Bilar/Sedan/sedan.tscn"] # change this to PackedScenes?

func accept_car():
	Info.MyCarPath = carScenes[selected]
