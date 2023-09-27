extends Node3D

@onready var animPlayer = $AnimationPlayer
@onready var bulletEmittersBase : Node3D = $BulletEmitters
@onready var bulletEmitters = $BulletEmitters.get_children()

@export var automatic = false

var firePoint : Node3D
var bodiesToExclude : Array = []

@export var damage = 5
@export var ammo = 30

@export var attackRate = 0.2
var attackTimer : Timer
var canAttack = true

signal firedSig
signal outOfAmmoSig

func _ready() -> void:
	attackTimer = Timer.new()
	attackTimer.wait_time = attackRate
	attackTimer.connect("timeout", FinishAttack())
	attackTimer.one_shot = true

func Initialise(InFirePoint : Node3D, InBodies : Array) -> void:
	firePoint = InFirePoint
	bodiesToExclude = InBodies
	for bulletEmitter in bulletEmitters:
		bulletEmitter.SetDamage(damage)
		bulletEmitter.SetBodiesToExclude(InBodies)

func Attack(IsJustPressed : bool, IsHeld : bool):
	if !canAttack:
		return
	if automatic && !IsHeld:
		return
	elif !automatic && !IsJustPressed:
		return

	if ammo == 0:
		if IsJustPressed:
			outOfAmmoSig.emit()
		return

	if ammo > 0:
		ammo -= 1

	var startTransform

func FinishAttack():
	pass










