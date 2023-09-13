extends RigidBody2D

@onready var AsteroidMediumScene:PackedScene = load("res://Objects/AsteroidMedium.tscn")

@export var Speed:float = 200
@export var Health:float = 100.0: set=SetHealth
@export var SpawnObjects:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = randf_range(0,360)

func _physics_process(delta):
	apply_central_force(transform.x.normalized()*Speed*delta)

func AddDamage(DamageValue:float)->void:
	SetHealth(Health-DamageValue)

func SetHealth(value:float)->void:
	Health = value
	if value <= 0:
		Destroy()

func Destroy():
	if SpawnObjects:
		for i in 3:
			var AsteroidMedium:RigidBody2D = AsteroidMediumScene.instantiate()
			get_parent().add_child(AsteroidMedium)
			AsteroidMedium.translate(position)
	queue_free()
