extends Node2D

var building = preload("res://Buildings/building.tscn")

var speed = 2

var velocity = Vector2()

var rocks = 0
var wood = 0



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
	if Input.is_action_pressed("shoot1"):
		shootFella(get_global_mouse_position(), "one")
	if Input.is_action_pressed("shoot2"):
		shootFella(get_global_mouse_position(), "two")	
	if Input.is_action_pressed("shoot3"):
		shootFella(get_global_mouse_position(), "three")
	if Input.is_action_pressed("build"):
		attemptBuilding()
	velocity = velocity.normalized() * speed
	

func _process(delta):
	get_input()
	position += velocity * speed


func shootFella(mousePos, fellaName):
	get_tree().get_first_node_in_group(fellaName).shoot(mousePos)

func attemptBuilding():
	if rocks >= 0 && wood >= 5:
		rocks -= 0
		wood -= 5
		var newBuilding = building.instantiate()
		newBuilding.position = get_global_mouse_position()
		get_parent().add_child(newBuilding)
	pass

func giveRocks():
	rocks += 1
	updateResources()
	
func giveWood():
	wood += 1
	updateResources()

func updateResources():
	$resources.text = "Rocks: " + str(rocks) + ", Wood: " + str(wood)

