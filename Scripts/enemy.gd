extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float = 300.0
var side := -1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_wall():
		side *= -1
	var direction : float = side
	
	if direction < 0.0:
		animated_sprite_2d.set_flip_h(false)
	else:
		animated_sprite_2d.set_flip_h(true)
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_deferred("reload_current_scene")
