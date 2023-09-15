extends Effect

class_name AddFuelEffect

@export var FuelValue:float = 0

func Start(Entity, World):
	pass

func Process(Entity, World):
	if 'Fuel' in Entity:
		Entity.Fuel += FuelValue

func End(Entity, World):
	pass
