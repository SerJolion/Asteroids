extends RigidBody2D

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")

@onready var Particles:GPUParticles2D = $Particles
@onready var BulletPostition:Node2D = $BulletPosition
@onready var InvincibleTimer:Timer = $InvincibleTimer

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var ContactDamage:float = 50.0
@export var EnergyRestoreSpeed:float = 0.01
@export var ShootEnergyCost: float = 10.0

var Health:float = 1 : set = SetHealth
var Energy:float = 1 : set = SetEnergy

var Invincible:bool = false

func _ready():
	Health = MaxHealth
	Energy = MaxEnergy

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		Shoot()

	var rot = Input.get_axis("ui_left", "ui_right")
	var vel = Input.get_axis('ui_up', 'ui_down') 
	
	if rot:
		apply_torque(rot * RotationSpeed * delta)
	
	if vel:
		Particles.emitting = true
		apply_central_force(-transform.x.normalized() * vel * Speed)
	else:
		Particles.emitting = false
	Energy = clamp(Energy+EnergyRestoreSpeed, 0, MaxEnergy)

func AddDamage(DamageValue:float)->void:
	if !Invincible:
		SetHealth(Health - DamageValue)

func SetHealth(value:float)->void:
	Health = value
	if Health <= 0:
		Destroy()

func SetEnergy(value:float)->void:
	Energy = value

func Destroy():
	queue_free()

func Shoot():
	if Energy >= ShootEnergyCost:
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.translate(BulletPostition.global_position)
		Bullet.rotation = rotation

func _on_hurt_box_body_entered(body):
	if body != self:
		if linear_velocity.length() > 100:
			AddDamage(ContactDamage)
			Invincible = true
			InvincibleTimer.start()

func _on_invincible_timer_timeout():
	Invincible = false
