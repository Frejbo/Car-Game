extends GPUParticles3D

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()
