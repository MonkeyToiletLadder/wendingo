extends KinematicBody2D

var speed = 0
var type = "enemy"
var velocity = Vector2.ZERO
var knockdir = Vector2.ZERO
var spritedir = "down"
var player = 1
var damage = 0
var facing = dir.down

var hitstun = 0
var health = 1

var keys = 0

onready var world = get_node("..")

func _ready():
	if type == "enemy":
		set_collision_mask_bit(1,1)
		set_physics_process(false)

func is_action_pressed(action):
	return Input.is_action_pressed(str("player",player,"_",action))

func is_action_just_pressed(action):
	return Input.is_action_just_pressed(str("player",player,"_",action))

func controls_loop():
	var left  = is_action_pressed("left") or Input.is_action_pressed("ui_left")
	var right = is_action_pressed("right") or Input.is_action_pressed("ui_right")
	var up    = is_action_pressed("up") or Input.is_action_pressed("ui_up")
	var down  = is_action_pressed("down") or Input.is_action_pressed("ui_down")
	velocity.x = -int(left) + int(right)
	velocity.y = -int(up) + int(down)
	
func movement_loop():
	var motion = null
	if hitstun == 0:
		motion = velocity.normalized() * speed
	else:
		motion = knockdir.normalized() * 125
	move_and_slide(motion, dir.center)
	
func spritedir_loop():
	match velocity:
		dir.left:
			spritedir = "left"
		dir.right:
			spritedir = "right"
		dir.up:
			spritedir = "up"
		dir.down:
			spritedir = "down"
			
func facing_loop():
	match velocity:
		dir.left:
			facing = dir.left
		dir.right:
			facing = dir.right
		dir.up:
			facing = dir.up
		dir.down:
			facing = dir.down
			
func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)
		
func damage_loop():
	if hitstun > 0:
		hitstun -= 1
	else:
		if type == "enemy" and health <= 0:
			var death_animation = preload("res://enemies/enemy_death.tscn").instance()
			get_parent().add_child(death_animation)
			death_animation.global_transform = global_transform
			drop_keys()
			queue_free()
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and body.get("damage") != null and body.get("type") != type:
			health -= body.get("damage")
			hitstun = 10
			knockdir = global_transform.origin - body.global_transform.origin

func use_item(item):
	var newitem = item.instance()
	newitem.own = self
	newitem.add_to_group(str(newitem.get_name(), self))
	get_node("..").add_child(newitem)
	
	if get_tree().get_nodes_in_group(str(newitem.get_name(),self)).size() > newitem.maxamount:
		newitem.queue_free()

func drop_keys():
	for key in range(keys):
		var instance = preload("res://pickups/key.tscn").instance()
		instance.global_position = global_position + Vector2(rand_range(-16,16),rand_range(-16,16))
		get_node("..").add_child(instance)
