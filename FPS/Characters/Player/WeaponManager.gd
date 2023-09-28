extends Node3D
class_name WeaponManager

enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

var firePoint : Node3D
var bodiesToExclude : Array = []

@onready var weapons = $Weapons.get_children()
var currentSlot = 0
var currentWeapon = null

func _ready() -> void:
	pass

func Initialise(InFirePoint: Node3D, InBodies : Array):
	firePoint = InFirePoint
	bodiesToExclude = InBodies
	for weapon in weapons:
		if weapon.has_method("Initialise"):
			weapon.Initialise(InFirePoint, InBodies)
	SwitchToWeaponSlot(1)

func Attack(IsJustPressed : bool, IsHeld : bool):
	if currentWeapon == null:
		return
	if currentWeapon.has_method("Attack"):
		currentWeapon.Attack(IsJustPressed, IsHeld)

func SwitchToNextWeapon():
	currentSlot = (currentSlot + 1) % slots_unlocked.size()
	if !slots_unlocked[currentSlot]:
		SwitchToNextWeapon()
	else:
		SwitchToWeaponSlot(currentSlot)

func SwitchToLastWeapon():
	currentSlot = posmod((currentSlot - 1) , slots_unlocked.size())
	if !slots_unlocked[currentSlot]:
		SwitchToLastWeapon()
	else:
		SwitchToWeaponSlot(currentSlot)

func SwitchToWeaponSlot(index : int):
	if index < 0 or index>= slots_unlocked.size():
		return
	if !slots_unlocked[currentSlot]:
		return
	DisableAllWeapons()
	currentWeapon = weapons[index]
	if currentWeapon.has_method("SetActive"):
		currentWeapon.SetActive()
	else:
		currentWeapon.hide()

func DisableAllWeapons():
	for weapon in weapons:
		if weapon.has_method("SetInactive"):
			weapon.SetInactive()
		else:
			weapon.hide()

