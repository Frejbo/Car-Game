extends Node

signal global_info_changed
signal game_started

var PlayerName := "Unknown player"
var global_info = {"seed":randi(), "players":{}}
