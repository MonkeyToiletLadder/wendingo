extends Position2D

onready var player = get_parent()
onready var shield_collision = $shield/CollisionShape2D

func _ready():
	$shield.connect("area_entered",self,"on_area_entered")

func on_area_entered(area):
	var parent = area.get_parent()
	if parent.name == "rock":
		area.queue_free()

func _process(delta):
	rotation = get_parent().facing.angle()
	if player.velocity != Vector2.ZERO:
		shield_collision.disabled = true
	else:
		shield_collision.disabled = false
