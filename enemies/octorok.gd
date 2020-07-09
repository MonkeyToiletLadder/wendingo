extends "res://engine/entity.gd"

onready var target = get_node("../player")

var distance_left = 0
var distance = 16
var first_seen = false
var trigger_timer = 0

var state = "default"

func _init():
	speed = 25
	health = 1
	damage = 1
	distance_left = distance
	velocity = dir.rand()
	type = "enemy"
	facing = dir.down
	
func _physics_process(delta):
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	var sight = space_state.intersect_ray(global_position, global_position + facing * 64,[self])
	state = "default"
	if sight.has("collider"):
		if sight.collider.name == "player":
			state = "shoot"
	
	match state:
		"default":
			state_default(delta)
		"shoot":
			state_shoot(delta)

func state_default(delta):
	if velocity != Vector2.ZERO:
		$anim.play("default")
	distance_left -= speed * delta
	if distance_left <= 0:
		distance_left = distance
		velocity = dir.rand()
		var dx = floor((position.x - target.position.x) / map.tile_size.x)
		var dy = floor((position.y - target.position.y) / map.tile_size.y)
		if abs(dy) > 4:
			velocity.y = -sign(dy)
			velocity.x = 0
	match spritedir:
		"left": rotation = PI/2
		"right": rotation = -PI/2 
		"up": rotation = PI
		"down": rotation = 0
	facing_loop()
	spritedir_loop()
	movement_loop()
	damage_loop()
	first_seen = true
	
func state_shoot(delta):
	var trigger_delay
	match spritedir:
		"left": rotation = PI/2
		"right": rotation = -PI/2 
		"up": rotation = PI
		"down": rotation = 0
	movement_loop()
	damage_loop()
	velocity = dir.center
	trigger_timer += delta
	if first_seen: trigger_delay = 0
	else: trigger_delay = 2
	first_seen = false
	if trigger_timer > trigger_delay:
		trigger_timer = 0
		shoot(preload("res://items/rock.tscn"))
		
func shoot(item):
	var instance = item.instance()
	instance.velocity = facing
	instance.position = position
	instance.type = type
	world.add_child(instance)
