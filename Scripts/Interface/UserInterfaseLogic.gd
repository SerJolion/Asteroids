extends Control

@onready var EndGamePanelScene:PackedScene =load("res://Objects/Interfaces/EndGamePanel.tscn")

@onready var HealthBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/HealthContainer/HealthBar
@onready var EnergyBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/EnergyContainer/EnergyBar
@onready var FuelBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/FuelContainer/FuelBar
@onready var EffectIconContainer:HBoxContainer = $MarginContainer/VBoxContainer/EffectsIconContainer

var ActiveEffectIcons:Dictionary = {}

func Init(player:Node2D)->void:
	player.HealthChanged.connect(UpdateHealthBar)
	player.EnergyChanged.connect(UpdateEnergyBar)
	player.FuelChanget.connect(UpdateFuelBar)
	player.EffectAdded.connect(AddActiveEffectIcon)
	player.EffectRemoved.connect(RemoveEffectIcon)

func UpdateHealthBar(value:float, MaxValue:float)->void:
	HealthBar.value = (value * 100)/MaxValue

func UpdateEnergyBar(value:float, MaxValue:float)->void:
	EnergyBar.value = (value * 100)/MaxValue

func UpdateFuelBar(value:float, MaxValue:float)->void:
	FuelBar.value = (value * 100)/MaxValue

func ShowEndGamePanel(Title:String, TitleColor:Color):
	var EndGamePanel:Control = EndGamePanelScene.instantiate()
	add_child(EndGamePanel)
	EndGamePanel.SetTitle(Title, TitleColor)

func AddActiveEffectIcon(effect:Effect):
	if effect.VisibleIcon:
		var NewIcon:TextureRect = TextureRect.new()
		NewIcon.name = effect.Id+'_icon'
		NewIcon.texture = load(effect.PathToIcon)
		EffectIconContainer.add_child(NewIcon)
		ActiveEffectIcons[effect.Id] = NewIcon

func RemoveEffectIcon(EffectName:String):
	if EffectName in ActiveEffectIcons.keys():
		ActiveEffectIcons[EffectName].queue_free()
		ActiveEffectIcons.erase(EffectName)
