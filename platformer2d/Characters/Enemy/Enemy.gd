extends KinematicBody2D

export var speed = 150
export var jump_speed = 100
export var gravity = 200

var is_jump = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

func _ready():
	set_physics_process(true)
	direction.x = -1

func _physics_process(delta):
	_move(delta)

func _move(delta):
	
	if $time_jump.is_stopped():
		is_jump = true
		$time_jump.start()
	else:
		is_jump = false
		$spr.animation = "move"
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	
	var get_col = get_slide_collision(get_slide_count()-1)
	
	if is_on_floor():
		velocity.y += 0
		
		if is_jump:
			velocity.y = -jump_speed
			$spr.animation = "jump"
	
	if get_col != null:
		if get_col.collider.get_name() == "Player":
			if get_col.collider.shield == false:
				get_col.collider._resistir()
				global_var.lives -= 1