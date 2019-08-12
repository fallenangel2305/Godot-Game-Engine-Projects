extends StaticBody2D

var coin = preload("res://Scenes/Coin/Coin.tscn")

func _spawn_coin():
	var newCoin = coin.instance()
	get_parent().add_child(newCoin)
	newCoin.global_position = global_position + Vector2(0,-85)

func _move():
	if $anim.is_playing() == false:
		$anim.play("mov")
		$spr.frame = 1
