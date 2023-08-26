extends Panel


func _on_create_new_pressed() -> void:
	show()


func _on_cancel_pressed() -> void:
	hide()
	$LineEdit.clear()


func _on_create_pressed() -> void:
	if $LineEdit.text == "":
		OS.alert("Please enter a name for your map!")
		return
	
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9_.- ]")
	if regex.search($LineEdit.text):
		OS.alert("The name cannot contain special characters. Only A-Z and 0-9 is allowed at the moment.")
		return
	
	get_parent().new_map($LineEdit.text)
