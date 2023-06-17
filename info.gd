extends Node

signal global_info_changed
signal game_started

var PlayerName := "Unknown player"
var MyCarPath : String
var global_info = {"players":{}}

#var my_cars_scene_path : String

#@rpc("reliable", "any_peer") # remove any_peer?
#func get_car_path():
#	print("Sendiong")
#	get_node("/root/main").add_remote_players_car.rpc_id(multiplayer.get_remote_sender_id(), my_cars_scene_path)
