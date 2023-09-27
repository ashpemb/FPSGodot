extends Node3D
class_name BulletEmitter

var hit_effect = preload("res://FX/bullet_hit_fx.tscn")

@export var distance = 10000
var bodies_to_exclude = []
var damage = 1

func SetDamage(InDamage : int):
	damage = InDamage

func SetBodiesToExclude(InBodies : Array):
	bodies_to_exclude = InBodies

func Fire():
	var space_state = get_world_3d().get_direct_space_state()
	var our_pos = global_transform.origin
	var RayCastParams = PhysicsRayQueryParameters3D.create(our_pos, our_pos - global_transform.basis.z * distance, 1 + 2 + 4,bodies_to_exclude)
	RayCastParams.collide_with_areas = true
	var result = space_state.intersect_ray(RayCastParams)
	if result && result.collider.has_method("hurt"):
		result.collider.hurt(damage, result.normal)
	elif result:
		var hit_fx_inst = hit_effect.instantiate()
		get_tree().get_root().add_child(hit_fx_inst)
		hit_fx_inst.global_transform.origin = result.position

		if result.normal.angle_to(Vector3.UP) < 0.00005:
			return
		if result.normal.angle_to(Vector3.DOWN) < 0.00005:
			hit_fx_inst.rotate(Vector3.RIGHT, PI)
			return

		var y = result.normal
		var x = y.cross(Vector3.UP)
		var z = x.cross(y)
		hit_fx_inst.global_transform.basis = Basis(x, y, z)
