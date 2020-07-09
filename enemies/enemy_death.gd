extends Node2D

func _ready():
	$anim.play("death")
	$anim.connect("animation_finished",self,"destroy")

func destroy(animation):
	queue_free()
