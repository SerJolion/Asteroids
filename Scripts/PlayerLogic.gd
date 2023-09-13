extends CharacterBody2D

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")

@onready var Particles:GPUParticles2D = $Particles
@onready var BulletPostition:Node2D = $BulletPosition

@export var Health:float = 100.0

const SPEED = 150
const ROTATION_SPEED = 5

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		Shoot()

	var rot = Input.get_axis("ui_left", "ui_right")
	var vel = Input.get_axis('ui_up', 'ui_down') 
	
	
	if rot:
		rotation += rot * ROTATION_SPEED * delta
	
	if vel:
		Particles.emitting = true
		velocity = lerp(velocity, -transform.x.normalized() * vel * SPEED, 0.01)
	else:
		Particles.emitting = false
		velocity = lerp(velocity,Vector2.ZERO,0.01)
		
	move_and_slide()

func Shoot():
	var Bullet:Node2D = BulletScene.instantiate()
	get_parent().add_child(Bullet)
	Bullet.translate(BulletPostition.global_position)
	Bullet.rotation = rotation
