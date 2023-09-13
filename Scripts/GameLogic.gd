extends Node

@onready var World:Node2D = $World
@onready var UserInterface:Control = $InterfaceLayer/UserInterfase

# Called when the node enters the scene tree for the first time.
func _ready():
	UserInterface.Init(World.GetPlayer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
