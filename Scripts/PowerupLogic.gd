extends Node2D

@export_file('*.png') var PathToVisualSprite:String
@export_file('*.tres') var PathToCurrentEffect:String

var CurrentEffect:Effect

func _ready():
	CurrentEffect = load(PathToCurrentEffect)

func _process(delta):
	pass

func _on_pickup_area_body_entered(body):
	if body.has_method('AddEffect'):
		body.AddEffect(CurrentEffect)
		queue_free()
