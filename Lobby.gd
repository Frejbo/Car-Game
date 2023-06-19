extends Control

var MenuCard = preload("res://PlayerMenuCard.tscn")
var playerCards = {}

func _ready() -> void:
	update_cards()
	if not is_multiplayer_authority():
		$start.hide()
		$wait_for_host.show()
	
	multiplayer.peer_disconnected.connect(remove_player_card)
	multiplayer.peer_connected.connect(update_cards)
	multiplayer.connected_to_server.connect(update_cards)

func remove_player_card(player_id):
	playerCards.erase(player_id)
	$VBoxContainer.get_node(str(player_id)).queue_free()

@onready var playersNode = get_node("/root/main/menu/world/Players")
func update_cards() -> void:
	for player in playersNode.get_children():
		if playerCards.has(player.name.to_int()):
			if player.get_node("Vehicles").car == playerCards[player.name.to_int()]["car"]: continue
			# switch icon of already existing card
			playerCards[player.name.to_int()]["car"] = player.get_node("Vehicles").car
			playerCards[player.name.to_int()]["card"].set_icon(playerCards[player.name.to_int()]["car"])
		
		else:
			# add card
			if not Info.global_info["players"].has(player.name.to_int()): continue # haven't recieved via rpc yet.
			
			var card = MenuCard.instantiate()
			playerCards[player.name.to_int()] = {"car":player.get_node("Vehicles").car, "card":card, "player_node":player}
			card.name = player.name
			card.display_name = Info.global_info["players"][player.name.to_int()]["display_name"]
			$VBoxContainer.add_child(card)
			card.set_icon(playerCards[player.name.to_int()]["car"])


func _on_start_pressed() -> void:
	get_parent().start.rpc()
