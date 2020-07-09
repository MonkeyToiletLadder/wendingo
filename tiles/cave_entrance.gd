extends Area2D

export(Vector2) var entrancedir = dir.up
export(Vector2) var exitdir = dir.up
export(String) var cave_name = ""
#export(Vector2) var entrancepos = Vector2(0,0)
#export(Vector2) var exitpos = Vector2(0,0)

func _ready():
	connect("body_entered",self,"on_body_entered")
	connect("body_exited",self,"on_body_exited")

func on_body_entered(body):
	if body.name == "player":
		body.state = "cave"
		body.on_cave_entered(self,get_node("cave_exit"))
		
func on_body_exited(body):
	if body.name == "player":
		body.state = "default"
