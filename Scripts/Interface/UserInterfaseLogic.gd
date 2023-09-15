extends Control

@onready var EndGamePanelScene:PackedScene =load("res://Objects/Interfaces/EndGamePanel.tscn")

@onready var HealthBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/HealthContainer/HealthBar
@onready var EnergyBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/VBoxContainer/EnergyBar
@onready var VinScoreLabel:Label = $MarginContainer/VBoxContainer/BarsContainer/VinScoreLabel

func Init(player:Node2D)->void:
	player.HealthChanged.connect(UpdateHealthBar)
	player.EnergyChanged.connect(UpdateEnergyBar)

func UpdateHealthBar(value:float, MaxValue:float)->void:
	HealthBar.value = (value * 100)/MaxValue

func UpdateEnergyBar(value:float, MaxValue:float)->void:
	EnergyBar.value = (value * 100)/MaxValue

func UpdateVinScore(CurrentScore:int, ScoreForVin:int)->void:
	VinScoreLabel.text = '{0} / {1}'.format([CurrentScore, ScoreForVin])

func ShowEndGamePanel(Title:String, TitleColor:Color):
	var EndGamePanel:Control = EndGamePanelScene.instantiate()
	add_child(EndGamePanel)
	EndGamePanel.SetTitle(Title, TitleColor)