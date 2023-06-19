extends Control

signal hostGame
signal joinGame

const lobby = preload("res://Lobby.tscn")

func valid_name() -> bool:
	if $VBoxContainer/name.text == "":
		OS.alert("Please enter a name first")
		return false
	Info.PlayerName = $VBoxContainer/name.text
	return true


func _on_host_pressed() -> void:
	if !valid_name(): return
	Info.PlayerName = $VBoxContainer/name.text
	emit_signal("hostGame")
	
	add_child(lobby.instantiate())
	$VBoxContainer.hide()
	set_last_used_car()


func _on_join_pressed() -> void:
	if !valid_name(): return
	Info.PlayerName = $VBoxContainer/name.text
	emit_signal("joinGame", $VBoxContainer/HBoxContainer/IP.text)
	
	add_child(lobby.instantiate())
	$VBoxContainer.hide()
	set_last_used_car()

@rpc("call_local", "reliable")
func start():
	Info.game_started.emit()
	$Lobby.queue_free()


func _process(_delta: float) -> void:
	$Label.text = str(multiplayer.get_unique_id())


func _notification(what: int) -> void:
	if what == NOTIFICATION_EXIT_TREE:
		save()

func save():
	print("save")
	var config = ConfigFile.new()
	config.set_value("about", "config_version", Info.CONFIG_VERSION)
	
	config.set_value("last_used", "display_name", $VBoxContainer/name.text)
	config.set_value("last_used", "IP", $VBoxContainer/HBoxContainer/IP.text)
	if $world/Players.has_node(str(multiplayer.get_unique_id())):
		config.set_value("last_used", "car", $world/Players.get_node(str(multiplayer.get_unique_id())+"/Vehicles").car)
	else:
		print("Haven't started, unable to save last used car to config file.")
	
	config.save("user://config.cfg")


func _ready() -> void:
	prefill_last_values()

func prefill_last_values():
	var config = ConfigFile.new()
	
	if config.load("user://config.cfg") != OK:
		print("Couln't prefill values.")
		return
	
	if Info.CONFIG_VERSION != config.get_value("about", "config_version"):
		print("Config file is from older version, deleting.")
		config.clear()
		config.save("user://config.cfg")
		return
	
	$VBoxContainer/name.text = config.get_value("last_used", "display_name")
	$VBoxContainer/HBoxContainer/IP.text = config.get_value("last_used", "IP")

func set_last_used_car():
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	print(config.get_value("last_used", "car", 0))
	$world/Players.get_node(str(multiplayer.get_unique_id())).set_car(config.get_value("last_used", "car", 0))
