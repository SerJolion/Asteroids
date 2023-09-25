extends Control

@onready var HealthBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/HealthContainer/HealthBar
@onready var EnergyBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/EnergyContainer/EnergyBar
@onready var FuelBar:ProgressBar = $MarginContainer/VBoxContainer/BarsContainer/FuelContainer/FuelBar
@onready var EffectIconContainer:HBoxContainer = $MarginContainer/VBoxContainer/EffectsIconContainer
@onready var PauseMEnuPanel:Panel = $MarginContainer/VBoxContainer/Main/PauseMenuPanel
@onready var MessagePanelScene:PackedScene = load('res://Objects/Interfaces/MessagePanel.tscn')


var PauseOpened:bool = false
var CurrentMessagePanel:Control
var MessageOpened:bool = false

var ActiveEffectIcons:Dictionary = {}

func _ready():
	PauseMEnuPanel.hide()
	HealthBar.tooltip_text = ''' Это прочность твоего корабля.\nКак тольуо она станет равна 0 ты проиграешь. '''
	EnergyBar.tooltip_text = '''Это энергия твоего корабля.\nЭнергия необходима для совершение выстрелов '''
	FuelBar.tooltip_text = '''Это топливо твоего корабля.\nДля того, чтобы улететь с этого астероидного \nполя нобходимо заполнить бак топливом'''

func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		if CurrentMessagePanel == null:
			if PauseOpened:
				ClosePauseMenu()
			else:
				ShowPauseMenu()

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

func ShowMessagePanel(Message:String, ClickFoo:Callable = Callable())->void:
	await get_tree().create_timer(0.1).timeout
	var MessagePanel:Panel = MessagePanelScene.instantiate()
	MessagePanel.UserInterface = self
	CurrentMessagePanel = MessagePanel
	$MarginContainer/VBoxContainer/Main.add_child(MessagePanel)
	MessagePanel.SetText(Message)
	MessagePanel.SetCallback(ClickFoo)
	Global.Pause(true)

func CloseMessagePanel()->void:
	if CurrentMessagePanel != null:
		CurrentMessagePanel.queue_free()
		Global.Pause(false)

func ShowPauseMenu()->void:
	Global.Pause(true)
	PauseMEnuPanel.show()
	PauseOpened = true

func ClosePauseMenu()->void:
	Global.Pause(false)
	PauseMEnuPanel.hide()
	PauseOpened = false

func AddActiveEffectIcon(effect:Effect):
	if effect.VisibleIcon:
		var NewIcon:TextureRect = TextureRect.new()
		NewIcon.name = effect.Id+'_icon'
		NewIcon.texture = load(effect.PathToIcon)
		NewIcon.tooltip_text = '''{0}\n{1}'''.format([effect.DisplayName, effect.Description])
		EffectIconContainer.add_child(NewIcon)
		ActiveEffectIcons[effect.Id] = NewIcon

func RemoveEffectIcon(EffectName:String):
	if EffectName in ActiveEffectIcons.keys():
		ActiveEffectIcons[EffectName].queue_free()
		ActiveEffectIcons.erase(EffectName)

func _on_resume_button_pressed():
	ClosePauseMenu()

func _on_main_menu_button_pressed():
	Global.Pause(false)
	Global.SetStartScene()

func _on_exit_button_pressed():
	Global.Exit()

func _on_message_ok_button_pressed():
	CloseMessagePanel()
