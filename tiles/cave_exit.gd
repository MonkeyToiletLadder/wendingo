extends Area2D

onready var entrance = get_node("..")

func _ready():
	connect("body_entered",self,"on_body_entered")
	connect("body_exited",self,"on_body_exited")

func on_body_entered(body):
	if body.name == "player":
		body.state = "cave"
		body.on_cave_exited(entrance,self)
		
func on_body_exited(body):
	if body.name == "player":
		body.state = "default"
