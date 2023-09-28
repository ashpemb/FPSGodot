extends Node3D
class_name Weapon

@onready var animPlayer : AnimationPlayer = $AnimationPlayer
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
	self.add_child(attackTimer)
	attackTimer.wait_time = attackRate
	attackTimer.connect("timeout", FinishAttack)
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

	var startTransform = bulletEmittersBase.global_transform
	bulletEmittersBase.global_transform = firePoint.global_transform
	for bulletEmitter in bulletEmitters:
		bulletEmitter.Fire()
	bulletEmittersBase.global_transform = startTransform
	animPlayer.stop()
	animPlayer.play("Attack")
	firedSig.emit()
	canAttack = false
	attackTimer.start()

func FinishAttack():
	canAttack = true

func SetActive():
	show()

func SetInactive():
	animPlayer.play("Idle")
	hide()










