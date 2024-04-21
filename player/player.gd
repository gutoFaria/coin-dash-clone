extends Area2D

signal pickup
signal hurt

@onready var _animated_sprite = $AnimatedSprite2D

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += velocity * speed * delta
	
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)
	
	if velocity.length() > 0:
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")
	if velocity.x !=0:
		_animated_sprite.flip_h = velocity.x < 0

func start():
	set_process(true)
	position = screensize / 2
	_animated_sprite.play("idle")

func die():
	_animated_sprite.play("hurt")
	set_process(false)
	


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
