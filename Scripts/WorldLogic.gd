extends Node2D

signal GameObjectDestroed(Id:String)
signal PlayerDestroed

@onready var PlayerScene:PackedScene = load("res://Objects/player.tscn")
@onready var AsteroidSCene:PackedScene = load("res://Objects/Enemies/AsteroidLarge.tscn")
@onready var EnemyShipScene:PackedScene = load("res://Objects/Enemies/EnemyShip.tscn")

@onready var Player:RigidBody2D = null
@onready var PlayerStartPosition:Marker2D = $PlayerStartPosition
@onready var AsteroidSpawnPoint:PathFollow2D = $AsteroidSpawnPath/AsteroidSpawPoint
@onready var AsteroidSpawnPath:Path2D = $AsteroidSpawnPath

@onready var MaxXCoord:int = 0
@onready var MaxYCoord:int = 0

var AsteroidsDestroedCount:int = 0
var EnemyShipsDestroed:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.size_changed.connect(SetMaxCoord)
	Player = PlayerScene.instantiate()
	add_child(Player)
	Player.translate(PlayerStartPosition.position)
	Player.SetColor(Global.PlayerColor)
	SetMaxCoord()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetMaxCoord():
	var WindowSize:Vector2 = DisplayServer.window_get_size()
	MaxXCoord = WindowSize.x
	MaxYCoord = WindowSize.y
	AsteroidSpawnPath.curve.set_point_position(0, Vector2(-50, -50))
	AsteroidSpawnPath.curve.set_point_position(4, Vector2(-50, -50))
	AsteroidSpawnPath.curve.set_point_position(1, Vector2(-50, WindowSize.y + 50))
	AsteroidSpawnPath.curve.set_point_position(2, Vector2(WindowSize.x + 50, WindowSize.y + 50))
	AsteroidSpawnPath.curve.set_point_position(3, Vector2(WindowSize.x + 50, -50))

func GetPlayer()->RigidBody2D:
	return Player

func SpawnEnemy()->void:
	var Chance:float  = randf()
	AsteroidSpawnPoint.progress_ratio = randf()
	if randf() <= 0.4:
		var NewShip:RigidBody2D = EnemyShipScene.instantiate()
		NewShip.translate(AsteroidSpawnPoint.global_position)
		NewShip.Target = Player
		add_child(NewShip)
	else:
		var NewAsteroid:RigidBody2D = AsteroidSCene.instantiate()
		add_child(NewAsteroid)
		NewAsteroid.translate(AsteroidSpawnPoint.position)
		var Direction:Vector2 = Vector2.ZERO
		if AsteroidSpawnPoint.position.x > MaxXCoord:
			Direction.x = -1
			#Direction.y = randi_range(0,MaxYCoord)
		if AsteroidSpawnPoint.position.x <= 0:
			Direction.x = 1
			#Direction.y = randi_range(0,MaxYCoord)
		if AsteroidSpawnPoint.position.y > MaxYCoord:
			#Direction.x = randi_range(0,MaxXCoord)
			Direction.y = -1
		if AsteroidSpawnPoint.position.y <= 0:
			#Direction.x = randi_range(0,MaxXCoord)
			Direction.y = 1
		NewAsteroid.Speed = randf_range(50.0, 200.0)
		NewAsteroid.constant_force = Direction.normalized() * NewAsteroid.Speed
		NewAsteroid.RotationSpeed = randf_range(1.0, 3.0)

func AddParticlesObject(Count:int, OneShot:bool, LifeTime:float, Explosion:bool ,ParticleMaterial:ParticleProcessMaterial, Position:Vector2, color:Color=Color.WHITE)->void:
	var Particles:GPUParticles2D = GPUParticles2D.new()
	Particles.amount = Count
	Particles.lifetime = LifeTime
	if OneShot:
		Particles.one_shot = OneShot
		get_tree().create_timer(LifeTime+0.5).timeout.connect(Particles.call_deferred.bind('queue_free'))
	if Explosion:
		Particles.explosiveness = 1
	Particles.process_material = ParticleMaterial
	Particles.self_modulate = color
	Add2DObject(Particles, Position)

func AddSoundObject(SoundPath:String, Position:Vector2):
	var SoundObject:AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	SoundObject.finished.connect(SoundObject.queue_free)
	SoundObject.stream = load(SoundPath)
	SoundObject.autoplay = true
	SoundObject.bus = 'Effects'
	Add2DObject(SoundObject, Position)

func Add2DObject(Obj:Node2D, Position:Vector2 = Vector2.ZERO)->void:
	call_deferred("add_child",Obj)
	#add_child(Obj)
	Obj.translate(Position)
	print('Объект {0} добавлен в мир'.format([Obj.name]))

func ObjectDestroed(Id:String):
	GameObjectDestroed.emit(Id)
	match Id:
		'enemy_ship':
			pass
		'asteroid_large':
			pass
