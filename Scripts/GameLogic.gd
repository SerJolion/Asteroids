extends Node

@export_multiline var FirstMessageText:String = ''
@export_multiline var SecondMessageText:String = ''
@export_multiline var VinMessageText:String = ''
@export_multiline var LoseMessageText:String = ''
@export_multiline var EndMessageText:String = ''
@export_multiline var FirstEnemyMessageText:String = ''
@export_multiline var FirstPowerUpMessageText:String = ''

@onready var World:Node2D = $World
@onready var UserInterface:Control = $InterfaceLayer/UserInterfase
@onready var AsteroidSpawnTimer:Timer = $AteroidSpawnTimer
@onready var AmbientSoundPlayer:AudioStreamPlayer = $AmbientSoundPlayer

func _ready():
	UserInterface.Init(World.GetPlayer())
	UserInterface.ShowMessagePanel(FirstMessageText, UserInterface.ShowMessagePanel.bind(SecondMessageText))
	World.GetPlayer().FuelIsFull.connect(PlayerVin)
	World.PlayerDestroed.connect(PlayerLose)
	World.GameEntitySpawned.connect(ShowEnemyTipMessage)
	World.GameObjectDestroed.connect(ShowPowerUpTipMessage)

func _on_ateroid_spawn_timer_timeout():
	World.SpawnEnemy()
	AsteroidSpawnTimer.start()

func ShowPowerUpTipMessage(EnemyIp:String):
	if EnemyIp == 'enemy_ship':
		UserInterface.ShowMessagePanel(FirstPowerUpMessageText)
		World.GameObjectDestroed.disconnect(ShowPowerUpTipMessage)

func ShowEnemyTipMessage(EnemyIp:String):
	if EnemyIp == 'enemy_ship':
		UserInterface.ShowMessagePanel(FirstEnemyMessageText)
		World.GameEntitySpawned.disconnect(ShowEnemyTipMessage)

func PlayerVin():
	UserInterface.ShowMessagePanel(VinMessageText, UserInterface.ShowMessagePanel.bind(EndMessageText, Global.SetStartScene))

func PlayerLose():
	UserInterface.ShowMessagePanel(LoseMessageText, UserInterface.ShowMessagePanel.bind(EndMessageText, Global.SetStartScene))
