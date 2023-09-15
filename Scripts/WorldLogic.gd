extends Node2D

signal GameObjectDestroed(Score:int)
signal PlayerDestroed

@onready var PlayerScene:PackedScene = load("res://Objects/player.tscn")
@onready var AsteroidSCene:PackedScene = load("res://Objects/AsteroidLarge.tscn")

@onready var Player:RigidBody2D = null
@onready var PlayerStartPosition:Marker2D = $PlayerStartPosition
@onready var AsteroidSpawnPoint:PathFollow2D = $AsteroidSpawnPath/AsteroidSpawPoint

@onready var MaxXCoord:int =  ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var MaxYCoord:int  = ProjectSettings.get_setting("display/window/size/viewport_height")

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = PlayerScene.instantiate()
	add_child(Player)
	Player.translate(PlayerStartPosition.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetPlayer()->RigidBody2D:
	return Player

func SpawnAsteroid()->void:
	var NewAsteroid:Node2D = AsteroidSCene.instantiate()
	AsteroidSpawnPoint.progress_ratio = randf()
	add_child(NewAsteroid)
	NewAsteroid.translate(AsteroidSpawnPoint.position)
	var Direction:Vector2 = Vector2.ZERO
	if AsteroidSpawnPoint.position.x > MaxXCoord:
		Direction.x = -1
		Direction.y = randi_range(0,MaxYCoord)
	if AsteroidSpawnPoint.position.x <= 0:
		Direction.x = 1
		Direction.y = randi_range(0,MaxYCoord)
	if AsteroidSpawnPoint.position.y > MaxYCoord:
		Direction.x = randi_range(0,MaxXCoord)
		Direction.y = -1
	if AsteroidSpawnPoint.position.y <= 0:
		Direction.x = randi_range(0,MaxXCoord)
		Direction.y = 1
	NewAsteroid.SetDirection(Direction.normalized())
	

func AddParticlesObject(Count:int, OneShot:bool, LifeTime:float, Explosion:bool ,ParticleMaterial:ParticleProcessMaterial, Position:Vector2)->void:
	var Particles:GPUParticles2D = GPUParticles2D.new()
	Particles.amount = Count
	Particles.lifetime = LifeTime
	if OneShot:
		Particles.one_shot = OneShot
		get_tree().create_timer(LifeTime+0.5).timeout.connect(Particles.call_deferred.bind('queue_free'))
	if Explosion:
		Particles.explosiveness = 1
	Particles.process_material = ParticleMaterial
	Add2DObject(Particles, Position)

func AddSoundObject(SoundPath:String, Position:Vector2):
	var SoundObject:AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	SoundObject.finished.connect(SoundObject.queue_free)
	SoundObject.stream = load(SoundPath)
	SoundObject.autoplay = true
	Add2DObject(SoundObject, Position)

func Add2DObject(Obj:Node2D, Position:Vector2 = Vector2.ZERO)->void:
	add_child(Obj)
	Obj.translate(Position)
	print('Объект {0} добавлен в мир'.format([Obj.name]))

func ObjectDestroed(Score:int):
	GameObjectDestroed.emit(Score)
