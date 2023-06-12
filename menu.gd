extends Control

signal hostGame
signal joinGame

const lobby = preload("res://Lobby.tscn")

func _ready() -> void:
	get_tree().paused = true
#	pass

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


func _on_join_pressed() -> void:
	if !valid_name(): return
	Info.PlayerName = $VBoxContainer/name.text
	emit_signal("joinGame", $VBoxContainer/HBoxContainer/IP.text)
	
	add_child(lobby.instantiate())
	$VBoxContainer.hide()

@rpc("call_local", "reliable")
func start():
	get_tree().paused = false
	$Lobby.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
