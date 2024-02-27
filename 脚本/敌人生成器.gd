extends Node2D

#@onready var 世界 = get_node("/root/世界")
@onready var 世界 = get_node("/root/世界")

signal hit_p

var 敌人_scene := preload("res://场景/敌人.tscn")
var 生成_points := []
func _ready():
	for i in get_children():
		if i is Marker2D:
			生成_points.append(i)



func _on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")   
	#获取场景树中所有属于"enemies"节点组的节点，并将这些节点存储在enemies变量中。
	if enemies.size() < get_parent().max_enemies:
		var 生成物 = 生成_points[randi() % 生成_points.size()]
		var 敌人 = 敌人_scene.instantiate()
		敌人.position = 生成物.position
		敌人.hit_player.connect(hit)  #接收 敌人.hit_player 信号关联函数hit
		世界.add_child(敌人)
		敌人.add_to_group("enemies") #把生成敌人放到 数组enemies 里
	
func hit():
	hit_p.emit()
