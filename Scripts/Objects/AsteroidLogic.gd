extends RigidBody2D

@onready var AsteroidMediumScene:PackedScene = load("res://Objects/AsteroidMedium.tscn")
@onready var DestroyParticlesMaterial:ParticleProcessMaterial = load('res://Materials/Particles/AsteroidDestroy.material')

@export var Speed:float = 200.0
@export var RotationSpeed:float = 150.0
@export var Health:float = 100.0: set=SetHealth
@export var SpawnObjects:bool = false
@export var SpawnPositionOffset:int = 50
@export var SpawnObjectsCount:int = 1
@export_file('*.tscn') var SpawnObjectScenePath

var Direction:Vector2
var MaxXCoord:int
var MaxYCoord

func _ready():
	rotation = randf_range(0,360)
	Direction = Vector2(1,0).rotated(randf()*2.0*PI)
	constant_torque = RotationSpeed
	constant_force = Direction * Speed
	MaxXCoord = get_parent().MaxXCoord
	MaxYCoord = get_parent().MaxYCoord

func _physics_process(delta):
	if position.x > MaxXCoord + 200 or position.x < -200 or position.y > MaxYCoord+200 or position.y < -200:
		queue_free()

func AddDamage(DamageValue:float)->void:
	SetHealth(Health-DamageValue)

func SetDirection(value:Vector2)->void:
	Direction = value

func SetHealth(value:float)->void:
	Health = value
	if value <= 0:
		Destroy()

func Destroy():
	if SpawnObjects:
		var SpawObjectScene:PackedScene = load(SpawnObjectScenePath)
		for i in SpawnObjectsCount:
			var NewSpawnObject:Node2D = SpawObjectScene.instantiate()
			get_parent().add_child(NewSpawnObject)
			var Position:Vector2 = position + Vector2(randi_range(-SpawnPositionOffset,SpawnPositionOffset), randi_range(-SpawnPositionOffset,SpawnPositionOffset))
			NewSpawnObject.translate(Position)
	get_parent().AddParticlesObject(30, true, 0.5, true, DestroyParticlesMaterial, position)
	get_parent().ObjectDestroed(10)
	call_deferred('queue_free')
