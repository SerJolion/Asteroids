extends RigidBody2D

signal HealthChanged(NewValue, MaxValue)
signal EnergyChanged(NewValue, MaxValue)
signal FuelChanget(NewValue, MaxValue)
signal FuelIsFull
signal EffectAdded(effect:Effect)
signal EffectRemoved(EffectId)

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")
@onready var PewSound:AudioStreamMP3 = load("res://Sound/pew.mp3")

@onready var Particles:GPUParticles2D = $Particles
@onready var BulletPostition:Node2D = $BulletPosition
@onready var InvincibleTimer:Timer = $InvincibleTimer
@onready var AudioPlayer:AudioStreamPlayer2D = $AudioPlayer
@onready var DisplayWidth:int =  ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var DisplayHeight:int = ProjectSettings.get_setting("display/window/size/viewport_height")

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var FireDamage:float = 10
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var MaxFuel:float = 10.0
@export var ContactDamage:float = 50.0
@export var EnergyRestoreSpeed:float = 0.5
@export var ShootEnergyCost: float = 10.0

var Health:float = 1 : set = SetHealth
var Energy:float = 1 : set = SetEnergy
var Fuel:float = 1 : set = SetFuel
var Effects:Dictionary = {}

var Invincible:bool = false

func _ready():
	#Health = MaxHealth
	Health = 1.0
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

	for EffectId in Effects.keys():
		var CurrentEffect:Effect = Effects[EffectId]
		CurrentEffect.Process(self,get_parent())
		match CurrentEffect.Type:
			0:
				RemoveEffect(EffectId)
			1:
				pass
			2:
				CurrentEffect.LifeTime -= delta
				if CurrentEffect.LifeTime <= 0:
					RemoveEffect(EffectId)

func AddEffect(_Effect:Effect):
	if not _Effect.Id in Effects.keys():
		Effects[_Effect.Id] = _Effect
		_Effect.Start(self,get_parent())
		EffectAdded.emit(_Effect)

func RemoveEffect(EffectId:String):
	if EffectId in Effects.keys():
		Effects[EffectId].End(self,get_parent())
		Effects.erase(EffectId)
		EffectRemoved.emit(EffectId)

func AddDamage(DamageValue:float)->void:
	if !Invincible:
		SetHealth(Health - DamageValue)
		Invincible = true
		InvincibleTimer.start()

func SetHealth(value:float)->void:
	HealthChanged.emit(value, MaxHealth)
	Health = value
	if Health <= 0:
		Destroy()

func SetEnergy(value:float)->void:
	EnergyChanged.emit(value, MaxEnergy)
	Energy = value

func SetFuel(value:float)->void:
	FuelChanget.emit(value, MaxFuel)
	Fuel = value
	if Fuel >= MaxFuel:
		FuelIsFull.emit()

func Destroy():
	queue_free()

func Shoot():
	if Energy >= ShootEnergyCost:
		Energy -= ShootEnergyCost
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.Damage = FireDamage
		Bullet.translate(BulletPostition.global_position)
		Bullet.rotation = rotation
		AudioPlayer.stream = PewSound
		AudioPlayer.play()

func _on_invincible_timer_timeout():
	Invincible = false

func _on_body_entered(body):
	if body.has_method('AddDamage'):
		body.AddDamage(ContactDamage)
