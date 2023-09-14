extends Node2D

@export var Speed:float = 400.0
@export var Damage:float = 5.0
@export var LifeTime:float = 10.0

func _physics_process(delta):
	var Velocity = transform.x.normalized() * Speed * delta
	translate(Velocity)
	LifeTime -= delta
	if LifeTime <= 0:
		queue_free()

func _on_hit_box_body_entered(body):
	Hit(body)

func Hit(Target:Node2D):
	if Target.has_method('AddDamage'):
		Target.AddDamage(Damage)
		queue_free()
