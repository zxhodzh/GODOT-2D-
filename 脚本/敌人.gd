extends CharacterBody2D

@onready var 世界 = get_node("/root/世界")
@onready var 玩家 = get_node("/root/世界/玩家")
@onready var animated_sprite_2d = $AnimatedSprite2D

signal hit_player
var item_scene := preload("res://场景/道具.tscn")
var explosion_scene := preload("res://场景/爆炸.tscn")
var alive : bool
var entered : bool
var speed : int = 80
var direction : Vector2
const DROP_CHANCE : float = 0.1

func _ready():
	var screen_rect = get_viewport_rect()
	entered = false
	alive = true
	var dist = screen_rect.get_center() - position
	
	if abs(dist.x) > abs(dist.y):  #代表左右的生成点
		direction.x = dist.x
		direction.y = 0
	else:
		direction.x = 0
		direction.y = dist.y
		
func _physics_process(_delta):
	if alive:
		animated_sprite_2d.animation = "run"
		if entered:
			direction = (玩家.position - position)
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		if velocity.x != 0:
			animated_sprite_2d.flip_h = velocity.x < 0
	else:
		pass
func die():
	alive = false
	animated_sprite_2d.stop()
	animated_sprite_2d.animation = "dead"
	$"敌人死亡".play()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)#为了怪物死亡后碰撞不起作用 而把禁用属性打开。
	if randf() <= DROP_CHANCE:
		drop_item()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	世界.add_child(explosion)
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS
func drop_item():
	var item = item_scene.instantiate() #触发子场景实例化
	item.position = position
	item.item_type = randi_range(0, 2)
	世界.call_deferred("add_child", item)#在下一帧之前，将 item 作为子节点添加到世界
	item.add_to_group("items")
func _on_入口timer_timeout():
	entered = true

func _on_area_2d_body_entered(_body): #检测到碰撞
	hit_player.emit()                 #就发出hit_player信号
