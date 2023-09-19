extends GameEntity

signal FuelChanget(NewValue, MaxValue)
signal FuelIsFull

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")
@onready var PewSound:AudioStreamMP3 = load("res://Sound/pew.mp3")

@onready var Particles:GPUParticles2D = $Particles
@onready var BulletPostition:Node2D = $BulletPosition
@onready var InvincibleTimer:Timer = $InvincibleTimer
#@onready var AudioPlayer:AudioStreamPlayer2D = $AudioPlayer
@onready var DisplayWidth:int =  ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var DisplayHeight:int = ProjectSettings.get_setting("display/window/size/viewport_height")

@export var FireDamage:float = 10
@export var MaxFuel:float = 100.0
@export var EnergyRestoreSpeed:float = 0.5
@export var ShootEnergyCost: float = 10.0

var Fuel:float = 1 : set = SetFuel

func _ready():
	Health = MaxHealth
	Energy = MaxEnergy
	AddEffect(load("res://Data/Effects/PlayerEnergyRegen.tres"))

func _exit_tree():
	get_parent().PlayerDestroed.emit()

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
	
	if position.x > DisplayWidth:
		position = Vector2(0,position.y)
	if position.x < 0:
		position = Vector2(DisplayWidth,position.y)
	if position.y > DisplayHeight:
		position = Vector2(position.x, 0)
	if position.y < 0:
		position = Vector2(position.x, DisplayHeight)
		
	ProcessEffects(delta)

func SetFuel(value:float)->void:
	Fuel = clamp(value, 0, MaxFuel)
	FuelChanget.emit(Fuel, MaxFuel)
	if Fuel >= MaxFuel:
		FuelIsFull.emit()

func Shoot():
	if Energy >= ShootEnergyCost:
		Energy -= ShootEnergyCost
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.Damage = FireDamage
		Bullet.translate(BulletPostition.global_position)
		Bullet.rotation = rotation
		PlaySound(PewSound)

func _on_invincible_timer_timeout():
	Invincible = false

func _on_body_entered(body):
	if body.has_method('Hurt'):
		body.Hurt(ContactDamage)
