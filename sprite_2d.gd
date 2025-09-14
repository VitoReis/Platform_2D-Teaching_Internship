extends Sprite2D

@export_range(0, 1) var bonus : int = 0 # 0 = SPEED | 1 = JUMP

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if bonus == 0:
			body.speed += 200
		elif bonus == 1:
			body.jump_velocity -= 200
		queue_free()
