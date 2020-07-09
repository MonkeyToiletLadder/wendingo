extends Area2D

export(bool) var disapears = false

func _ready():
	connect("body_entered",self,"on_body_entered")
	connect("area_entered",self,"on_area_entered")
	
func on_body_entered(body):
	pass

func on_area_entered(area):
	var parent = area.get_parent()
	if parent.name == "sword":
		on_body_entered(parent.get_parent())
