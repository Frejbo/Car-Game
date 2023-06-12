extends CanvasLayer

const playerCard = preload("res://PlayerMenuCard.tscn")

func add_player(peer_id):
#	if is_multiplayer_authority(): return
	var card = playerCard.instantiate()
	card.name = str(peer_id)
	$VBoxContainer.add_child(card)

func remove_player(peer_id):
	$VBoxContainer.get_node(str(peer_id)).queue_free()

#func _ready() -> void:
#	multiplayer.peer_connected.connect(add_player)
#	multiplayer.peer_disconnected.connect(remove_player)
