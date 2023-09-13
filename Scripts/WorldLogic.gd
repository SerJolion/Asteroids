extends Node2D

@onready var PlayerScene:PackedScene = load("res://Objects/player.tscn")
@onready var AsteroidSCene:PackedScene = load("res://Objects/AsteroidLarge.tscn")

@onready var Player:RigidBody2D = null
@onready var PlayerStartPosition:Marker2D = $PlayerStartPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = PlayerScene.instantiate()
	add_child(Player)
	Player.translate(PlayerStartPosition.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetPlayer()->RigidBody2D:
	return Player
