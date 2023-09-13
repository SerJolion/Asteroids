extends RigidBody2D

@export var Speed:float = 200
@export var Health:float = 100.0: set=SetHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = randf_range(0,360)

func _physics_process(delta):
	apply_central_force(transform.x.normalized()*Speed*delta)

func SetHealth(value:float)->void:
	Health = value
	if value <= 0:
		Destroy()

func Destroy():
	queue_free()
