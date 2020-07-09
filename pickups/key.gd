extends "res://pickups/pickup.gd"
	
func on_body_entered(body):
	if body.get("keys") != null:
		body.keys += 1
		queue_free()
