extends Control

@onready var HealthBar:ProgressBar = $VBoxContainer/BarsContainer/HealthBar
@onready var EnergyBar:ProgressBar = $VBoxContainer/BarsContainer/EnergyBar

var Player:RigidBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Init(player:Node2D)->void:
	Player = player
	Player.HealthChanged.connect(UpdateEnergyBar)
	Player.EnergyChanged.connect(UpdateEnergyBar)

func UpdateHealthBar(value:float, MaxValue:float)->void:
	HealthBar.value = (value * 100)/MaxValue

func UpdateEnergyBar(value:float, MaxValue:float)->void:
	EnergyBar.value = (value * 100)/MaxValue
