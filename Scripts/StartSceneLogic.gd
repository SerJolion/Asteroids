extends Node

@onready var World:Node2D = $World
@onready var MenuControll = $InterfaceLayer/MenuControll
@onready var AudioPlayer:AudioStreamPlayer = $AudioPlayer
@onready var OptionPanel:Panel = $InterfaceLayer/MenuControll/OptionPanel

@onready var PlayerColorPicker:ColorPickerButton = $InterfaceLayer/MenuControll/OptionPanel/MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer/PlayerColorContainer/PlayerColorPicker
@onready var BackgroundColorPicker:ColorPickerButton = $InterfaceLayer/MenuControll/OptionPanel/MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer/BackgroundColorContsiner/BackgroundColorPicker
@onready var SoundSlider:HSlider = $InterfaceLayer/MenuControll/OptionPanel/MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer/SoundSliderContainer/SoundSlider
@onready var MusicSlider:HSlider = $InterfaceLayer/MenuControll/OptionPanel/MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer/MusicSliderContainer/MusicSlider
@onready var EffectSlider:HSlider = $InterfaceLayer/MenuControll/OptionPanel/MarginContainer/VBoxContainer/Control/ScrollContainer/VBoxContainer/EffectSliderContainer/EffectSlider

func _ready():
	Global.Pause(false)
	CloseOption()

func OpenOption():
	PlayerColorPicker.color = Global.PlayerColor
	SoundSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Master'))
	MusicSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Music'))
	EffectSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Effects'))
	OptionPanel.show()
	

func CloseOption():
	OptionPanel.hide()

func PlaySound(Sound:AudioStream):
	AudioPlayer.stream = Sound
	AudioPlayer.play()

func _on_start_button_pressed():
	Global.SetMainScene()

func _on_option_button_pressed():
	OpenOption()

func _on_exit_button_pressed():
	Global.Exit()

func _on_accept_button_pressed():
	Global.PlayerColor = PlayerColorPicker.color
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Master'), SoundSlider.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), MusicSlider.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Effects'), EffectSlider.value)
	CloseOption()

func _on_cancel_button_pressed():
	CloseOption()
