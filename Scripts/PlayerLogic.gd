extends RigidBody2D

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")

@onready var Particles:GPUParticles2D = $Particles
@onready var BulletPostition:Node2D = $BulletPosition

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var Health:float = 100.0
@export var ContactDamage:float = 50.0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		Shoot()

	var rot = Input.get_axis("ui_left", "ui_right")
	var vel = Input.get_axis('ui_up', 'ui_down') 
	
	
#	if rot:
#		rotation += rot * RotationSpeed * delta
	
	if rot:
		apply_torque(rot * RotationSpeed * delta)
	
	if vel:
		Particles.emitting = true
		apply_central_force(-transform.x.normalized() * vel * Speed)
		#velocity = lerp(velocity, -transform.x.normalized() * vel * SPEED, 0.01)
	else:
		Particles.emitting = false
		#velocity = lerp(velocity,Vector2.ZERO,0.01)
		
	#move_and_slide()

func SetHealth(value:float)->void:
	Health = value
	if Health <= 0:
		Destroy()

func Destroy():
	queue_free()

func Shoot():
	var Bullet:Node2D = BulletScene.instantiate()
	get_parent().add_child(Bullet)
	Bullet.translate(BulletPostition.global_position)
	Bullet.rotation = rotation


func _on_hurt_box_body_entered(body):
	if body != self:
		SetHealth(Health-ContactDamage)
