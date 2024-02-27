extends Node2D


@export var bullet_scene : PackedScene


func _on_玩家_shoot(position , dir):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = position
	bullet.direction = dir.normalized()
	bullet.add_to_group("bullets")
