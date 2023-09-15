extends RigidBody2D

@onready var BulletScene:PackedScene = load("res://Objects/Bullet.tscn")
@export_node_path("Node2D") var PathToTarget

@onready var RayCast:RayCast2D = $RayCast2D

var Energy:float = 1
var Target:Node2D
var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if Target != null:
		var v = Target.global_position - global_position
		var Angle = v.angle()
		global_rotation = lerp_angle(global_rotation,Angle,0.02)
		if (Target.position - position).length() > 50:
			apply_central_force((Target.position - position).normalized()*100)
	if RayCast.is_colliding():
		if 'Fuel' in RayCast.get_collider():
			if Energy > 0:
				var Bullet:Node2D = BulletScene.instantiate()
				get_parent().add_child(Bullet)
				Bullet.Damage = 10
				Bullet.translate($Marker2D.global_position)
				Bullet.rotation = rotation
				Energy -= 1

func _on_area_2d_body_entered(body):
	if 'Fuel' in body:
		Target = body

func Seek():
	pass
