extends Node

@onready var World:Node2D = $World
@onready var MenuControll = $InterfaceLayer/MenuControll
@onready var AudioPlayer:AudioStreamPlayer = $AudioPlayer
@onready var MainScene:PackedScene = load("res://Scenes/main_scene.tscn")
@onready var OptionPanel:Panel = $InterfaceLayer/MenuControll/OptionPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Pause(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OpenOption():
	OptionPanel.show()

func CloseOption():
	OptionPanel.hide()

func _on_start_button_pressed():
	Global.SetScene(MainScene)


func _on_option_button_pressed():
	OpenOption()


func _on_exit_button_pressed():
	Global.Exit()


func _on_accept_button_pressed():
	pass # Replace with function body.


func _on_cancel_button_pressed():
	CloseOption()
