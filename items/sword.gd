extends Node2D

var type = null
var damage = 1
var maxamount = 1

var own = null

func _ready():
	type = own.type
	$anim.connect("animation_finished",self,"destroy")
	$anim.play(str("swing",own.spritedir))
	if own.has_method("state_swing"):
		own.state = "swing"
		
func destroy(animation):
	if own.has_method("state_swing"):
		own.state = "default"
	queue_free()
