extends Node

@export var VinScore:int = 50

@onready var World:Node2D = $World
@onready var UserInterface:Control = $InterfaceLayer/UserInterfase
@onready var AsteroidSpawnTimer:Timer = $AteroidSpawnTimer
@onready var AmbientSoundPlayer:AudioStreamPlayer = $AmbientSoundPlayer

func _ready():
	World.GetPlayer().FuelIsFull.connect(PlayerVin)
	UserInterface.Init(World.GetPlayer())
	World.PlayerDestroed.connect(PlayerLose)

func _on_ateroid_spawn_timer_timeout():
	World.SpawnAsteroid()
	AsteroidSpawnTimer.start()

func Pause(value:bool)->void:
	get_tree().paused = value

func PlayerVin():
	UserInterface.ShowEndGamePanel('Вы победили', Color.DARK_GREEN)
	Pause(true)

func PlayerLose():
	UserInterface.ShowEndGamePanel('Вы проиграли', Color.DARK_RED)
	Pause(true)
