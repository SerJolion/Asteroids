extends Node

@export var VinScore:int = 100


@onready var World:Node2D = $World
@onready var UserInterface:Control = $InterfaceLayer/UserInterfase
@onready var AsteroidSpawnTimer:Timer = $AteroidSpawnTimer

var CurrentScore:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	UserInterface.Init(World.GetPlayer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ateroid_spawn_timer_timeout():
	World.SpawnAsteroid()
	AsteroidSpawnTimer.start()
