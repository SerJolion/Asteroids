extends GameEntity

@export var FireDamage:float = 10
@export var ShootEnergyCost:float = 10
@export var EnergyRestoreValue:float = 0.5

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")

@onready var BulletPosition:Marker2D = $BulletPosition

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

func _physics_process(delta):
	if Target != null:
		#var VectorToTarget:Vector2 = Target.global_position - global_position
		var Steering:Vector2 = Vector2.ZERO
		
		
		Steering += Seek(Target)
		for obj in AvoidObjects:
			Steering += Flee(obj)
		
		var VectorToTarget:Vector2 = linear_velocity - transform.x
		var Angle = linear_velocity.angle()
		global_rotation = lerp_angle(global_rotation,Angle,0.5)
		
		apply_central_force(Steering)
#		if (Target.position - position).length() > 50:
#			apply_central_force((Target.position - position).normalized()*100)
		for body in $ShootArea.get_overlapping_bodies():
			if 'Fuel' in body:
				Shoot()
		
		ProcessEffects(delta)
#	ShootCoolDownTime -= delta
#	if ShootCoolDownTime <= 0:
#		CanShoot = true

func Shoot():
	if Energy >= ShootEnergyCost:
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.Damage = FireDamage
		Bullet.translate(BulletPosition.global_position)
		Bullet.rotation = rotation
		Energy -= ShootEnergyCost
		#ShootCoolDownTime = 0.5

func Seek(Target:Node2D):
	var DesiredForce:Vector2 = (Target.global_position - global_position).normalized() * Speed
	var Steering = DesiredForce - linear_velocity
	return Steering

func Flee(Target:Node2D):
	var DesiredForce:Vector2 = (global_position - Target.global_position).normalized() * Speed
	var Steering = DesiredForce - linear_velocity
	return Steering

func _on_shoot_area_body_entered(body):
	if 'Fuel' in body:
		Shoot()

func _on_area_2d_body_entered(body):
	if 'Fuel' in body:
		Target = body
	if 'SpawnObjects' in  body:
		AvoidObjects.append(body)

func _on_area_2d_body_exited(body):
	if body in AvoidObjects:
		AvoidObjects.erase(body)
