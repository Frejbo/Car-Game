extends Node

signal global_info_changed
signal game_started

const CONFIG_VERSION := 0

var PlayerName := "Unknown player"
enum cars {SUV, Sedan, Van}
const car_icons := {
	cars.SUV:"res://Bilar/SUV/suv.png",
	cars.Sedan:"res://Bilar/Sedan/sedan.png",
	cars.Van:"res://Bilar/Van/van.png"
}
#const car_paths = {
#	cars.SUV:"res://Bilar/SUV/suv.tscn",
#	cars.Sedan:"res://Bilar/Sedan/sedan.tscn"
#}
var global_info = {"players":{}}
