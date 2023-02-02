extends Node2D


var speed = 2

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shootFella(get_viewport().get_mouse_position())
	velocity = velocity.normalized() * speed
	

func _process(delta):
	get_input()
	position += velocity * speed


func shootFella(mousePos):
	var shootyDir = (mousePos - global_transform.origin).normalized()
	get_tree().get_first_node_in_group("fella").shoot(shootyDir)
