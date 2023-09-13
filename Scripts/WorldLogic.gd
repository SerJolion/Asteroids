extends Node2D

@onready var PlayerScene:PackedScene = load("res://Objects/player.tscn")
@onready var AsteroidSCene:PackedScene = load("res://Objects/AsteroidLarge.tscn")

@onready var Player:RigidBody2D = null
@onready var PlayerStartPosition:Marker2D = $PlayerStartPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = PlayerScene.instantiate()
	add_child(Player)
	Player.translate(PlayerStartPosition.position)
	AddParticlesObject(10,true, false, 1,load("res://Materials/Particles/ShipFire.material"), Vector2(500,500))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetPlayer()->RigidBody2D:
	return Player

func AddParticlesObject(Count:int, OneShot:bool, LifeTime:float, Explosion:bool ,ParticleMaterial:ParticleProcessMaterial, Position:Vector2)->void:
	var Particles:GPUParticles2D = GPUParticles2D.new()
	Particles.amount = Count
	Particles.lifetime = LifeTime
	if OneShot:
		Particles.one_shot = OneShot
		get_tree().create_timer(LifeTime+0.5).timeout.connect(Particles.queue_free)
	if Explosion:
		Particles.explosiveness = 1
	Particles.process_material = ParticleMaterial
	Add2DObject(Particles, Position)

func Add2DObject(Obj:Node2D, Position:Vector2 = Vector2.ZERO)->void:
	add_child(Obj)
	Obj.translate(Position)
	print('Объект {0} добавлен в мир'.format([Obj.name]))
