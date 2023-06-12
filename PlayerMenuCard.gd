extends AspectRatioContainer

#func _ready() -> void:
#	$HBoxContainer/name.text = get_node("/root/main/world/Players/"+str(multiplayer.get_unique_id())+"/VehicleBody3D/PlayerName").text
	
#	if is_multiplayer_authority():
#		$HBoxContainer/name.text = Info.PlayerName

#var i = 0
#func _process(delta: float) -> void:
#	if is_multiplayer_authority():
#		$HBoxContainer/name.text = str(i)
#		i+=1
