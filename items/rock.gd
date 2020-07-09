extends"res://engine/entity.gd"

var maxamount = 8

func _init():
	speed = 30
	damage = 1
	var parent = get_parent()
	type = "enemy"

func _ready():
	$area.connect("area_exited",self,"on_area_exited")
		
func _physics_process(delta):
	movement_loop()

func on_area_exited(area):
	if area.get_parent().name == "camera":
		queue_free()
