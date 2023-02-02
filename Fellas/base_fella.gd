extends Node2D

enum STATE {
	FOLLOWING,
	SHOOTING,
	FIGHTING,
	GATHERING,
	RETURNING
}

var player
var currentState
var speed = 5
var strength = 5
var shootDirection = Vector2.ZERO


var wood = 0
var rocks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = STATE.FOLLOWING
	player = get_tree().get_first_node_in_group("player")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		STATE.SHOOTING:
			$DetectionRadius.monitoring = true
			move(shootDirection, 1)
		STATE.FOLLOWING:
			if position.distance_to(player.position) > 100:
				var heading = (player.global_transform.origin - global_transform.origin).normalized()
				move(heading, 1)
		STATE.RETURNING:
			$G.hide()
			$DetectionRadius.monitoring = false
			if position.distance_to(player.position) > 100:
				var heading = (player.global_transform.origin - global_transform.origin).normalized()
				move(heading, 2)
			if position.distance_to(player.position) <= 100:
				currentState = STATE.FOLLOWING
				depositResources()
		STATE.GATHERING:
			gather()
		STATE.FIGHTING:
			fight()
	showState()

func move(heading, multiplier):
	position.x = lerpf(position.x, position.x + (heading.x * speed * multiplier), .5)
	position.y = lerpf(position.y, position.y + (heading.y * speed * multiplier), .5)

func shoot(mouseCoords):
	if currentState == STATE.FOLLOWING:
		currentState = STATE.SHOOTING
		var heading = (mouseCoords - global_position).normalized()
		shootDirection = heading
		$ShotTimer.start()

func gather():
	$GatherTimer.start()
	$G.show()
	wood = 1

func fight():
	rocks = 1
	pass


func depositResources():
	if rocks > 0:
		player.giveRocks()
	if wood > 0:
		player.giveWood()
	rocks = 0
	wood = 0




func showState():
	$StateLabel.text = "State: " + str(currentState)


func _on_shot_timer_timeout():
	currentState = STATE.RETURNING


func _on_detection_radius_area_entered(area):
	if area.getType() == "resource":
		currentState = STATE.GATHERING
	elif area.getType() == "enemy":
		currentState = STATE.FIGHTING

func _on_gather_timer_timeout():
	currentState = STATE.RETURNING
	
