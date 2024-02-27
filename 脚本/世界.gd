extends Node



var game_pause : bool
var wave : int
var difficulty : float
const DIFF_MULTIPLIER : float = 1.2
var max_enemies : int
var lives : int

func _ready():
	new_game()
	$"游戏结束"/Button.pressed.connect(new_game) #发出pressed信号到new_game函数
	#connect: 这是一个方法，用于将信号连接到某个方法或函数。当信号被触发时，所连接的方法或函数将被执行
	
func new_game():
	lives = 3
	wave = 1
	difficulty = 10.0
	$"敌人生成器"/Timer.wait_time = 1.0
	get_tree().call_group("items", "queue_free")
	reset()
	
func reset():
	max_enemies = int(difficulty)
	$"玩家".reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	#get_tree().call_group("items", "queue_free")
	$"用户界面"/"生命Label".text = "X " + str(lives)
	$"用户界面"/"关卡Label".text = "关卡 : " + str(wave)
	$"用户界面"/"敌人Label".text = "X " + str(max_enemies)
	$"游戏结束".hide()
	get_tree().paused = false
	
func _process(_delta):
	if is_wave_completed():
		wave += 1
		difficulty *= DIFF_MULTIPLIER
		if $"敌人生成器"/Timer.wait_time > 0.25:
			$"敌人生成器"/Timer.wait_time -= 0.05
		reset()
	

func _on_敌人生成器_hit_p():
	lives -= 1
	$用户界面/生命Label.text = "X " + str(lives)
	get_tree().paused = true
	reset()
	if lives <= 0:
		get_tree().paused = true 
		$"游戏结束"/"关卡幸存Label".text = "最高通关："+ str(wave - 1)
		$"游戏结束".show()
		
func is_wave_completed():
	var all_dead = true
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == max_enemies:
		for e in enemies:
			if e.alive:
				all_dead = false
		return all_dead
	else:
		return false
