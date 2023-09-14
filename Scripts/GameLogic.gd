extends Node

@export var VinScore:int = 20


@onready var World:Node2D = $World
@onready var UserInterface:Control = $InterfaceLayer/UserInterfase
@onready var AsteroidSpawnTimer:Timer = $AteroidSpawnTimer

var CurrentScore:int = 0: set = SetScore

# Called when the node enters the scene tree for the first time.
func _ready():
	UserInterface.Init(World.GetPlayer())
	World.GameObjectDestroed.connect(func(Score):CurrentScore+=Score)
	World.PlayerDestroed.connect(PlayerLose)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ateroid_spawn_timer_timeout():
	World.SpawnAsteroid()
	AsteroidSpawnTimer.start()

func SetScore(value:int)->void:
	CurrentScore = clamp(value, 0, VinScore)
	UserInterface.UpdateVinScore(CurrentScore, VinScore)
	if CurrentScore == VinScore:
		PlayerVin()

func Pause(value:bool)->void:
	get_tree().paused = value

func PlayerVin():
	UserInterface.ShowEndGamePanel('Вы победили', Color.DARK_GREEN)
	Pause(true)

func PlayerLose():
	UserInterface.ShowEndGamePanel('Вы проиграли', Color.DARK_RED)
	Pause(true)
