extends RigidBody2D

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var FireDamage:float = 10
@export var ContactDamage:float = 50.0
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var ShootCoolDownTime: = 0.5

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")

@onready var RayCast:RayCast2D = $RayCast2D
@onready var BulletPosition:Marker2D = $BulletPosition

var CanShoot:bool = true 
var Health:float = 1: set = SetHealth
var Energy:float = 1: set = SetEnergy
var Target:Node2D

func _ready():
	Health = MaxHealth
	Energy = MaxEnergy
	

func _physics_process(delta):
	if Target != null:
		var VectorToTarget:Vector2 = Target.global_position - global_position
		var Angle = VectorToTarget.angle()
		global_rotation = lerp_angle(global_rotation,Angle,0.02)
		if (Target.position - position).length() > 50:
			apply_central_force((Target.position - position).normalized()*100)
		for body in $ShootArea.get_overlapping_bodies():
			if 'Fuel' in body:
				Shoot()
	ShootCoolDownTime -= delta
	if ShootCoolDownTime <= 0:
		CanShoot = true
#	if RayCast.is_colliding():
#		if 'Fuel' in RayCast.get_collider():
#			Shoot()

func SetHealth(value:float)->void:
	Health = value
	if Health <= 0:
		queue_free()

func SetEnergy(value:float)->void:
	Energy = value

func Shoot():
	if CanShoot:
		var Bullet:Node2D = BulletScene.instantiate()
		get_parent().add_child(Bullet)
		Bullet.Damage = FireDamage
		Bullet.translate(BulletPosition.global_position)
		Bullet.rotation = rotation
		CanShoot = false
		ShootCoolDownTime = 0.5

func _on_area_2d_body_entered(body):
	if 'Fuel' in body:
		Target = body

func Seek():
	pass


func _on_shoot_area_body_entered(body):
	if 'Fuel' in body:
		Shoot()
