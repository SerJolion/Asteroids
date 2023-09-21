extends GameEntity

@onready var BulletScene:PackedScene = load("res://Objects/Projectiles/Bullet.tscn")
@onready var ShootSound:AudioStreamMP3 = load("res://Sound/pew.mp3")
@onready var DestroyParticlesMaterial:ParticleProcessMaterial = load('res://Materials/Particles/AsteroidDestroy.material')

@export var FireDamage:float = 10
@export var ShootEnergyCost:float = 10
@export var EnergyRestoreValue:float = 0.5
@export var SeekSlowingRadius:float = 100.0

@onready var VisionArea:Area2D = $VisionArea
@onready var ShootArea:Area2D = $ShootArea
@onready var BulletPosition:Marker2D = $BulletPosition
@onready var EngineFireParticles:GPUParticles2D = $EngineFireParticles

var SpawnablePowerups:Array = [ ]
var CanShoot:bool = true 
var Target:Node2D
var AvoidObjects:Array = []

func _ready():
	Health = MaxHealth
	Energy = MaxEnergy
	var EnergyRestore: EnergyRegenEffect = EnergyRegenEffect.new()
	EnergyRestore.Id = 'energy_restore'
	EnergyRestore.RegenValue = EnergyRestoreValue
	EnergyRestore.Type = 1
	AddEffect(EnergyRestore)
	SpawnablePowerups.append(load("res://Objects/Powerups/Energy.tscn"))
	SpawnablePowerups.append(load("res://Objects/Powerups/FuelPowerUp.tscn"))
	SpawnablePowerups.append(load("res://Objects/Powerups/MedKit.tscn"))

func _physics_process(delta):
	if Target != null:
		var Steering:Vector2 = Vector2.ZERO
		
		Steering += Seek(Target)
		for obj in AvoidObjects:
			Steering += Flee(obj)
		
		apply_central_force(Steering)
		RotateTo(Target)
		for body in ShootArea.get_overlapping_bodies():
			if 'Fuel' in body:
				Shoot()
		ProcessEffects(delta)

func SetColor(color:Color):
	Visual.color = color

func Shoot():
	if Energy >= ShootEnergyCost:
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.Damage = FireDamage
		Bullet.translate(BulletPosition.global_position)
		Bullet.rotation = rotation
		Energy -= ShootEnergyCost
		PlaySound(ShootSound)

func RotateTo(Target:Node2D):
	var VectorToTarget:Vector2 = linear_velocity - transform.x
	var Angle = linear_velocity.angle()
	global_rotation = lerp_angle(global_rotation,Angle,0.5)

func Seek(Target:Node2D):
	var DesiredForce:Vector2 = Target.global_position - global_position
	var Distance:float = DesiredForce.length()
	if Distance >= SeekSlowingRadius:
		DesiredForce = (Target.global_position - global_position).normalized() * Speed * (Distance / SeekSlowingRadius)
	else:
		DesiredForce = (Target.global_position - global_position).normalized() * Speed
	var Steering = DesiredForce - linear_velocity
	return Steering

func Flee(Target:Node2D):
	var DesiredForce:Vector2 = (global_position - Target.global_position).normalized() * Speed
	var Steering = DesiredForce - linear_velocity
	return Steering

func Destroy():
	get_parent().AddSoundObject('res://Sound/AsteroidDestroy.mp3', position)
	get_parent().AddParticlesObject(30, true, 1.5, true, DestroyParticlesMaterial, position, GetColor())
	var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
	var Chance:float = RNG.randf()
	if Chance <= 1.0:
		var Loot:Node2D = SpawnablePowerups[RNG.randi_range(0, len(SpawnablePowerups)-1 )].instantiate()
		get_parent().Add2DObject(Loot, global_position)
	super.Destroy()

func _on_shoot_area_body_entered(body):
	if 'Fuel' in body:
		Shoot()

func _on_vision_area_body_entered(body):
	if 'Fuel' in body:
		Target = body
	if 'SpawnObjects' in  body:
		AvoidObjects.append(body)

func _on_vision_area_body_exited(body):
	if body in AvoidObjects:
		AvoidObjects.erase(body)

func _on_body_entered(body):
	if body.has_method('Hurt'):
		body.Hurt(ContactDamage)
