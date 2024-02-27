extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var game_pause : bool
const START_SPEED : int = 300
const BOOST_SPEED : int = 500
const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1
var can_shoot : bool

signal shoot(position, dir)
var speed : int
var screen_size : Vector2
func _ready():
	
	screen_size = get_viewport_rect().size
	reset()

func reset():
	can_shoot = true
	position = screen_size / 2
	speed = START_SPEED
	$射击Timer.wait_time = NORMAL_SHOT
	

func get_input():
	
	var input_dir = Input.get_vector("left","right","up","down")
	velocity = input_dir.normalized() * speed
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir) #按下射击形成SHOOT信号
		$"射击音效".play()
		can_shoot = false
		$"射击Timer".start()
	


func _physics_process(_delta):
	get_input()
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size) # 限制位置范围在ZER0到screen_size之间。
	
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	animated_sprite_2d.animation = "walk" + str(angle) # 以鼠标所在的弧度范围，播放8个动画中相应的动画。
	
	
	if velocity.length() != 0:
		animated_sprite_2d.play()  #假如有移动就播放动画
	else:
		animated_sprite_2d.stop()
		animated_sprite_2d.frame = 1 #否则就不播放动画 而是播放动画中的1号帧

func boost():
	$加速Timer.start()
	speed = BOOST_SPEED
	
func quick_fire():
	$速射Timer.start()
	$射击Timer.wait_time = FAST_SHOT

func _on_timer_timeout():
	can_shoot = true


func _on_加速timer_timeout() -> void:
	speed = START_SPEED


func _on_速射timer_timeout() -> void:
	$射击Timer.wait_time = NORMAL_SHOT
