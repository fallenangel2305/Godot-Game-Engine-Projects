extends CanvasLayer

var coins = 0

func _ready():
	set_process(true)

func _process(delta):
	coins = global_var.coins
	
	if global_var.coins >= 10:
		$"hud_coins/1".visible = true
	else:
		$"hud_coins/1".visible = false 
	
	if global_var.lives == 4:
		$hud_lives.frame = 0
		$hud_lives2.frame = 0
	elif global_var.lives == 3:
		$hud_lives.frame = 1
	elif global_var.lives == 2:
		$hud_lives.frame = 2
	elif global_var.lives == 1:
		$hud_lives2.frame = 1
	elif global_var.lives == 0:
		$hud_lives2.frame = 2
	
	for i in range(2):
		if int(_get_digits(coins).size()) == i:
			return
		get_node("hud_coins/"+str(i)).frame = int(_get_digits(coins)[i])
	

func _get_digits(coins):
	var str_coins = str(coins)
	var digits = []
	
	for i in range(str_coins.length()):
		digits.append(str_coins[i])
	
	return digits
