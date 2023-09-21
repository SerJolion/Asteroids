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
	World.SpawnEnemy()
	AsteroidSpawnTimer.start()

func Pause(value:bool)->void:
	get_tree().paused = value

func PlayerVin():
	UserInterface.ShowMessagePanel('[color=green]Ты победил!', Global.SetStartScene)
	Pause(true)

func PlayerLose():
	UserInterface.ShowMessagePanel('[color=red]Ты проиграл!', Global.SetStartScene)
	Pause(true)
