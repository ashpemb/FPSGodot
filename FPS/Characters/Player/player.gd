extends CharacterBody3D

@onready var camera_3d = $Camera3D
@onready var character_mover : CharacterMover = $CharacterMover
@onready var health_manager : HealthManager = $HealthManager
@onready var weapon_manager : WeaponManager = $Camera3D/WeaponManagerNode

@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

var hotkeys = {
	KEY_1:0,
	KEY_2:1,
	KEY_3:2,
	KEY_4:3,
	KEY_5:4,
	KEY_6:5,
	KEY_7:6,
	KEY_8:7,
	KEY_9:8,
	KEY_0:9,
}

var dead = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.deadSig.connect(kill)
	(weapon_manager as WeaponManager).Initialise($Camera3D/FirePoint, [self])

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)
	if event is InputEventKey and event.is_pressed():
		event = event as InputEventKey
		if event.keycode in hotkeys:
			weapon_manager.SwitchToWeaponSlot(hotkeys[event.keycode])
	if  event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_manager.SwitchToNextWeapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_manager.SwitchToLastWeapon()

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if dead:
		return

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	var input_dir = Input.get_vector("move_left","move_right","move_forwards","move_backwards")
	var move_dir = (transform.basis * Vector3(input_dir.x, 0 , input_dir.y)).normalized()

	character_mover.set_move_dir(move_dir)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

	(weapon_manager as WeaponManager).Attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack"))

func hurt(damage, dir):
	health_manager.hurt(damage, dir)

func heal(amount):
	health_manager.heal(amount)

func kill():
	dead = true
	character_mover.freeze()
