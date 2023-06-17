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
	$carSelector.accept_car()
	emit_signal("hostGame")
	
	add_child(lobby.instantiate())
	$VBoxContainer.hide()
	$carSelector.hide()


func _on_join_pressed() -> void:
	if !valid_name(): return
	Info.PlayerName = $VBoxContainer/name.text
	$carSelector.accept_car()
	emit_signal("joinGame", $VBoxContainer/HBoxContainer/IP.text)
	
	add_child(lobby.instantiate())
	$VBoxContainer.hide()
	$carSelector.hide()

@rpc("call_local", "reliable")
func start():
	Info.game_started.emit()
	$Lobby.queue_free()

func _process(_delta) -> void:
	$Label.text = str(multiplayer.get_unique_id())
