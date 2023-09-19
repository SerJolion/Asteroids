extends Node2D

@export var CurrentEffect:Effect

func _process(delta):
	pass

func _on_pickup_area_body_entered(body):
	if body.has_method('AddEffect'):
		body.AddEffect(CurrentEffect)
		queue_free()
