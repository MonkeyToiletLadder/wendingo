extends StaticBody2D

func _ready():
	$area.connect("body_entered",self,"on_body_entered")
	
func on_body_entered(body):
	if body.get("keys") != null:
		if body.keys >= 1:
			body.keys -= 1
			queue_free()
