extends Effect

class_name EnergyRegenEffect

@export var RegenValue:float

func Start(Entity, World):
	pass

func Process(Entity, World):
	if 'Energy' in Entity:
		Entity.Energy += RegenValue

func End(Entity, World):
	pass

