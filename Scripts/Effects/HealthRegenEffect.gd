extends Effect

class_name HealthRegenEffect

@export var RegenValue:float

func Start(Entity, World):
	pass

func Process(Entity, World):
	if 'Health' in Entity:
		Entity.Health += RegenValue

func End(Entity, World):
	pass
