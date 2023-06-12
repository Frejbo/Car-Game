extends CanvasLayer

signal hostGame
signal joinGame

#const lobby = preload("res://Lobby.tscn") 

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
	
	
#	add_child(lobby.instantiate())
#	$Lobby.add_player(1)
	$Lobby.show()
	$VBoxContainer.hide()


func _on_join_pressed() -> void:
	if !valid_name(): return
	Info.PlayerName = $VBoxContainer/name.text
	emit_signal("joinGame", $VBoxContainer/HBoxContainer/IP.text)
	
	
#	add_child(lobby.instantiate())
	$Lobby.show()
	$VBoxContainer.hide()

