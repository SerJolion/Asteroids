extends Node

@onready var StartScene:PackedScene = load("res://Scenes/StartScene.tscn")
@onready var MainScene:PackedScene = load("res://Scenes/main_scene.tscn")

var PlayerColor:Color = Color.WHITE
var Backgroundcolor:Color = Color.BLACK

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetStartScene():
	SetScene(StartScene)

func SetMainScene():
	SetScene(MainScene)

func SetScene(Scene:PackedScene):
	get_tree().change_scene_to_packed(Scene)

func Pause(value:bool):
	get_tree().paused = value

func Exit():
	get_tree().quit()
