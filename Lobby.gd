extends Control

var MenuCard = preload("res://PlayerMenuCard.tscn")

func _ready() -> void:
	Info.global_info_changed.connect(update_cards)
	update_cards()
	
	if not is_multiplayer_authority():
		$start.hide()
		$wait_for_host.show()


func update_cards():
	# clean up
	while $VBoxContainer.get_child_count() > 0:
		$VBoxContainer.get_child(0).free()
	
	# place new
	for player in Info.global_info["players"].values():
		var card = MenuCard.instantiate()
		$VBoxContainer.add_child(card)
		
		var box = card.get_node("HBoxContainer")
		box.get_node("name").text = player["display_name"]


func _on_start_pressed() -> void:
	get_parent().start.rpc()
