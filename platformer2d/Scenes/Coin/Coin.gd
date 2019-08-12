extends StaticBody2D

func _ready():
	if $anim.is_playing() == false:
		$anim.play("mov_coin")