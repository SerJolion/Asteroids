extends GameEntity

@onready var DestroySound:AudioStreamMP3 = load("res://Sound/AsteroidDestroy.mp3")
@onready var HitSound:AudioStreamMP3 = load("res://Sound/AsteroidHitted.mp3")
@onready var DestroyParticlesMaterial:ParticleProcessMaterial = load('res://Materials/Particles/AsteroidDestroy.material')

@export var SpawnObjects:bool = false
@export var SpawnObjectsScenes:Array[String]

#@onready var Visual:Polygon2D = $Visual
#@onready var Colider:CollisionPolygon2D = $Colider
#@onready var AudioPlayer:AudioStreamPlayer2D = $AudioPlayer
@onready var SpawnPointsContainer:Node2D = $SpawnPoints

#var Direction:Vector2
var MaxXCoord:int
var MaxYCoord:int

func _ready():
	constant_torque = RotationSpeed
	MaxXCoord = get_parent().MaxXCoord
	MaxYCoord = get_parent().MaxYCoord

func _integrate_forces(state):
	if linear_velocity.length() > Speed:
		linear_velocity = linear_velocity.normalized() * Speed

func _physics_process(delta):
	if position.x > MaxXCoord + 200 or position.x < -200 or position.y > MaxYCoord+200 or position.y < -200:
		queue_free()

func Destroy():
	if SpawnObjects:
		for i in 3:
			var Scene:PackedScene = load(SpawnObjectsScenes[i])
			var NewSpawnObject:Node2D = Scene.instantiate()
			get_parent().add_child(NewSpawnObject)
			NewSpawnObject.translate($SpawnPoints.get_children()[i].global_position)
			if 'SpawnPointsContainer' in NewSpawnObject:
				NewSpawnObject.Speed = randf_range(100, 300)
				NewSpawnObject.constant_force = $SpawnPoints.get_children()[i].transform.x.normalized() * NewSpawnObject.Speed
				NewSpawnObject.RotationSpeed = randf_range(1.0, 3.0) 
	get_parent().AddParticlesObject(30, true, 1.5, true, DestroyParticlesMaterial, position, Visual.color)
	get_parent().AddSoundObject('res://Sound/AsteroidDestroy.mp3', position)
	super.Destroy()

func _on_body_entered(body):
	if body.has_method('Hurt'):
		body.Hurt(ContactDamage)
