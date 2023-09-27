extends Node3D

class_name HealthManager

signal deadSig
signal hurtSig
signal healedSig
signal health_changedSig
signal gibbedSig

@export var max_health = 100
var cur_health = 1

@export var gib_at = -10

func _ready() -> void:
	_init()

func _init() -> void:
	cur_health = max_health
	emit_signal("health_changedSig", cur_health)

func hurt(damage : int, dir : Vector3):
	if cur_health <= 0:
		return
	cur_health -= damage
	if cur_health <= gib_at:
		pass #TODO make gibs spawner
		emit_signal("gibbedSig")
	if cur_health <= 0:
		emit_signal("deadSig")
		print("dead")
	else:
		emit_signal("hurtSig")
	emit_signal("health_changedSig", cur_health)
	print("hurt ", damage, "current health ", cur_health )


func heal(amount : int):
	if cur_health <= 0:
		return
	cur_health += amount
	if cur_health > max_health:
		cur_health = max_health
	emit_signal("healedSig")
	emit_signal("health_changedSig", cur_health)
