extends PanelContainer

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ESC"): return
	
	visible = !visible
	match visible:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_exit_level_editor_pressed() -> void:
	$VBoxContainer/Loading.show()
	await get_tree().process_frame
	await get_tree().process_frame # need 2 process_frames to pass for some reason, otherwise loading label wont show
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
