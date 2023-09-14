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

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = randf_range(0,360)
	Direction = Vector2(1,0).rotated(randf()*2.0*PI)
	constant_torque = RotationSpeed
	constant_force = Direction * Speed

func _physics_process(delta):
	pass
	#apply_central_force(Direction.normalized()*Speed*delta)
	#apply_torque(RotationSpeed*delta)

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
	call_deferred('queue_free')
