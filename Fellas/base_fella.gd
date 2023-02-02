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
var shootDirection = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = STATE.FOLLOWING
	player = get_tree().get_first_node_in_group("player")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		STATE.SHOOTING:
			move(shootDirection)
		STATE.FOLLOWING:
			if position.distance_to(player.position) > 100:
				var heading = (player.global_transform.origin - global_transform.origin).normalized()
				move(heading)
		STATE.GATHERING:
			gather()
			pass
	showState()

func move(heading):
	position.x = lerpf(position.x, position.x + (heading.x * speed), .5)
	position.y = lerpf(position.y, position.y + (heading.y * speed), .5)

func shoot(direction):
	if currentState == STATE.FOLLOWING:
		currentState = STATE.SHOOTING
		shootDirection = direction
		$ShotTimer.start()

func gather():
	$GatherTimer.start()
	$G.show()

func showState():
	$StateLabel.text = "State: " + str(currentState)


func _on_shot_timer_timeout():
	currentState = STATE.FOLLOWING


func _on_detection_radius_area_entered(area):
	currentState = STATE.GATHERING


func _on_gather_timer_timeout():
	$G.hide()
	currentState = STATE.FOLLOWING
	
