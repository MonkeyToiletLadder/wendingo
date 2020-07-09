extends"res://engine/entity.gd"

onready var shield_collision = $pivot/shield/CollisionShape2D
onready var shield = $pivot/shield

var state = "default"

var viewport_size = get_viewport_rect().size
var new_position = null

func _init():
	keys = 0
	speed = 70
	health = 3
	type = "player"
	#position = viewport_size / 2
	
func _physics_process(delta):
	match state:
		"default":
			state_default()
		"swing":
			state_swing()
		"cave":
			state_cave()
			
func state_default():
	controls_loop()
	movement_loop()
	spritedir_loop()
	damage_loop()
	facing_loop()
	if velocity != Vector2.ZERO:
		anim_switch("walk")
	else:
		anim_switch("idle")
	if is_action_just_pressed("a") or Input.is_action_just_pressed("ui_a"):
		use_item(preload("res://items/sword.tscn"))
	if is_action_just_pressed("b") or Input.is_action_just_pressed("ui_b"):
		use_item(preload("res://items/bomb.tscn"))
		
func state_swing():
	anim_switch("useitem")
	movement_loop()
	damage_loop()
	velocity = dir.center
	
func state_cave():
	spritedir_loop()
	anim_switch("walk")
	if not $Tween.is_active() and new_position != null:
		global_position = new_position
		new_position = null
		modulate = Color(1,1,1)
	
func on_cave_entered(cave,exit):
	match cave.entrancedir:
		dir.up:
			global_position.x = cave.global_position.x
			velocity = dir.up
		dir.down:
			global_position.x = cave.global_position.x
			velocity = dir.down
		dir.left:
			global_position.y = cave.global_position.y
			velocity = dir.left
		dir.right:
			global_position.y = cave.global_position.y
			velocity = dir.right
	new_position = exit.global_position + cave.exitdir * 16
	$Tween.interpolate_property(self, "global_position", global_position, cave.global_position, 3)
	$Tween.interpolate_property(self, "modulate", Color(1,1,1), Color(0,0,0), 3)
	$Tween.start()
	
func on_cave_exited(cave,exit):
	match -cave.exitdir:
		dir.up:
			global_position.x = exit.global_position.x
			velocity = dir.up
		dir.down:
			global_position.x = exit.global_position.x
			velocity = dir.down
		dir.left:
			global_position.y = exit.global_position.y
			velocity = dir.left
		dir.right:
			global_position.y = exit.global_position.y
			velocity = dir.right
	new_position = cave.global_position + -cave.entrancedir * 16
	$Tween.interpolate_property(self,"global_position",global_position, exit.global_position,3)
	$Tween.start()
