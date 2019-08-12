extends KinematicBody2D

var speed = 350
var jump_speed = 900
var gravity = 1300

var swim = false
var cont = 0
var text_actual = null
var shield = false
var open_door = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

func _ready():
	set_physics_process(true)
	set_process(true)
	
	$spr.frame = 3

func _process(delta):
	if global_var.lives == 0 and global_var.punto != null:
		global_var.lives = 4
		global_position = global_var.punto
	
	if Input.is_action_just_pressed("ui_select") and open_door:
		$spr.animation = "open_door"
		$spr.playing = true
		yield($spr,"animation_finished")
		print("Bien, has pasado el nivel")
		get_tree().quit()
	
	if $time_shield.is_stopped() == false and $spr.self_modulate.a8 != 100:
		$spr.self_modulate.a8 -= 5
	elif $time_shield.is_stopped() and $spr.self_modulate.a8 != 255:
		$spr.self_modulate.a8 += 5
		shield = false
	
	if swim:
		$spr.animation = "swim"
		$spr.playing = true
		speed = 200
		jump_speed = 500
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_speed
	else:
		speed = 350
		jump_speed = 900
		gravity = 1300
	
	if Input.is_action_just_pressed("ui_down"):
		if cont == 0:
			_speak("¡Hola!")
			global_var.lives += 1
			print(global_var.lives)
		elif cont == 1:
			text_actual.queue_free()
			_speak(" ¿Esta fino, eh?")
		elif cont == 2:
			text_actual.queue_free()
			_speak("Para tener la segunda parte del juego es necesario que IndieLibre llegue a su meta de Patreon. :P")
		elif cont == 3:
			text_actual.queue_free()
			cont = 0
			return
		cont += 1

func _physics_process(delta):
	_move(delta)

func _speak(text):
	var container_text = load("res://Text/Label.tscn").instance()
	container_text._text(text)
	add_child(container_text)
	text_actual = container_text

func _move(delta):
	direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	
	if direction.y != 0 and swim == false:
		$spr.animation = "jump"
	
	if direction.x != 0 and direction.y == 0 and swim == false and open_door == false:
		$spr.animation = "mov"
		$spr.playing = true
		
	elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false:
		$spr.playing = false
		$spr.animation = "stop"
	
	if direction.x > 0:
		$spr.flip_h = false
	elif direction.x < 0:
		$spr.flip_h = true
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	
	var get_col = get_slide_collision(get_slide_count()-1)
	
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
		
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_speed
			direction.y = 1
	
	if get_col != null:
		if get_col.normal == Vector2(0,1):
			velocity.y = 0
		
		if get_col.collider.is_in_group("box") and get_col.normal == Vector2(0,1):
			if get_col.collider.is_in_group("boxCoin") and get_col.collider.get_node("spr").frame == 0:
				get_col.collider._spawn_coin()
				
			get_col.collider._move()
		
		elif get_col.collider.is_in_group("coin"):
			get_col.collider.queue_free()
			global_var.coins += 1
		elif get_col.collider.is_in_group("enemy") and get_col.normal == Vector2(0,-1):
			get_col.collider.queue_free()

func _resistir():
	shield = true
	velocity.y = -jump_speed
	
	if $time_shield.is_stopped():
		$time_shield.start()

func _on_swim_zone_body_entered(body):
	if body.get_name() == get_name():
		swim = true

func _on_swim_zone_body_exited(body):
	if body.get_name() == get_name():
		swim = false

func _on_Flag_body_entered(body):
	if body.get_name() == get_name():
		$"../Flag/spr".animation = "flag"
		global_var.punto = $"../Flag/spr".global_position

func _on_Enemy_barnacle_body_entered(body):
	if body.get_name() == get_name():
		if body.shield == false:
			_resistir()
			global_var.lives -= 1
			
func _on_Switch_body_entered(body):
	if body.get_name() == get_name():
		$"../Switch/spr".frame = 1
		$"../Door/spr".animation = "open"
		$"../Door/spr1".animation = "open"

func _on_Door_body_entered(body):
	if body is KinematicBody2D and $"../Door/spr".animation == "open":
		open_door = true

func _on_Door_body_exited(body):
	if body is KinematicBody2D:
		open_door = false 