extends Camera2D

func _ready():
	$area.connect("body_entered",self,"on_body_entered")
	$area.connect("body_exited",self,"on_body_exited")
	$area.connect("area_entered",self,"on_area_entered")
	$area.connect("area_exited",self,"on_area_exited")
	pass

func _process(delta):
	var screen_width = map.tile_size.x * map.screen_size.x
	var screen_height = map.tile_size.y * map.screen_size.y
	var pos = get_node("../player").global_position
	var x = floor(pos.x / screen_width) * screen_width
	var y = floor(pos.y / screen_height) * screen_height
	global_position = Vector2(x,y)

func on_body_entered(body):
	if body is KinematicBody2D:
		if body.type == "enemy":
			body.set_physics_process(true)
		
func on_body_exited(body):
	if body is KinematicBody2D:
		if body.type == "enemy":
			body.set_physics_process(false)

func on_area_entered(area):
	var parent = area.get_parent()
	if parent is KinematicBody2D:
		if parent.type == "enemy":
			parent.set_physics_process(true)
		
func on_area_exited(area):
	var parent = area.get_parent()
	if parent is KinematicBody2D:
		if parent.type == "enemy":
			parent.set_physics_process(false)
