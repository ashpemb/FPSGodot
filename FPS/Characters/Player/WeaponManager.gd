class_name WeaponManager
extends Node3D

enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

@onready var weapons = $Weapons.get_children()
var cur_slot = 0
var cur_weapon = null

func _ready() -> void:
	pass

func SwitchToNextWeapon():
	cur_slot = (cur_slot + 1) % slots_unlocked.size()
	if !slots_unlocked[cur_slot]:
		SwitchToNextWeapon()
	else:
		SwitchToWeaponSlot(cur_slot)

func SwitchToLastWeapon():
	cur_slot = posmod((cur_slot - 1) , slots_unlocked.size())
	if !slots_unlocked[cur_slot]:
		SwitchToLastWeapon()
	else:
		SwitchToWeaponSlot(cur_slot)

func SwitchToWeaponSlot(index : int):
	if index < 0 or index>= slots_unlocked.size():
		return
	if !slots_unlocked[cur_slot]:
		return
	DisableAllWeapons()
	cur_weapon = weapons[index]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.show()

func DisableAllWeapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()

