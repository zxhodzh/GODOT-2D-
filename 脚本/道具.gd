extends Area2D
#@onready var 玩家 = get_node("/root/世界/玩家")

@onready var 世界 = get_node("/root/世界")
@onready var 生命Label = get_node("/root/世界/用户界面/生命Label")
#var item_type = randi_range(0, 2)
var item_type : int #项目类型
var coffee_box = preload("res://assets/items/coffee_box.png")
var health_box = preload("res://assets/items/health_box.png")
var gun_box = preload("res://assets/items/gun_box.png")
var textures = [coffee_box, health_box, gun_box]

func _ready() -> void:
	$Sprite2D.texture = textures[item_type]
	


func _on_body_entered(body: Node2D) -> void:
	
	
	if item_type == 0:
		body.boost()
	elif item_type == 1:
		世界.lives += 1
		生命Label.text = "X " + str(世界.lives)
		
	elif item_type == 2:
		body.quick_fire()
	$"拾取音效".play()
	$Timer.start()
	


#func _on_拾取音效_finished() -> void:
	#queue_free()


func _on_timer_timeout() -> void:
	queue_free()
