extends Control

var MenuCard = preload("res://PlayerMenuCard.tscn")

func _ready() -> void:
	Info.display_names_changed.connect(update_cards)
	update_cards()
	
	if is_multiplayer_authority():
		$start.show()
		$wait_for_host.hide()


func update_cards():
	# clean up
	while $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).free()
	
	# place new
	for player in Info.display_names.values():
		var card = MenuCard.instantiate()
		$VBoxContainer.add_child(card)
		
		var box = card.get_node("HBoxContainer")
		box.get_node("name").text = player


func _on_start_pressed() -> void:
	get_parent().start.rpc()
