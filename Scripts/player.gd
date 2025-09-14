extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var area_2d: Area2D = $Area2D

@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
var last_facing : float = 1.0       # 1 = direita, -1 = esquerda

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	area_2d.monitoring = false
	camera_2d.zoom = Vector2(2.0, 2.0)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	camera_2d.global_position = global_position
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		last_facing = direction
		animated_sprite_2d.flip_h = last_facing < 0
	
	if Input.is_action_just_pressed("ui_accept"):
		animated_sprite_2d.play("attack", 1.0, false)
		area_2d.monitoring = true
		if last_facing < 0:
			area_2d.global_position = Vector2(global_position.x - 34.0, global_position.y)
		else:
			area_2d.global_position = Vector2(global_position.x + 22.0, global_position.y)
	
	if direction:
		if (not animated_sprite_2d.is_playing() and animated_sprite_2d.animation == "attack") or animated_sprite_2d.animation != "attack":
			area_2d.monitoring = false
			animated_sprite_2d.play("run", 1.0, false)
		velocity.x = direction * speed
	else:
		if (not animated_sprite_2d.is_playing() and animated_sprite_2d.animation == "attack") or animated_sprite_2d.animation != "attack":
			area_2d.monitoring = false
			animated_sprite_2d.play("idle", 1.0, false)
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
