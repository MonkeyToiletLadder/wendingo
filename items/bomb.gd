extends Area2D

func _ready():
	connect("animation_finished",self,"destroy")
	$anim.play("defualt")
	$CollisionShape2D.disabled = true
	
func destroy():
	$CollisionShape2D.disabled = false
	$Timer.start()
	
func _physics_process(delta):
	if $Timer.time_left == 0:
		queue_free()
