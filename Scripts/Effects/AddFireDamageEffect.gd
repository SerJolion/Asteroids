extends Effect

class_name AddFireDamageEffect

@export var Value:float = 0

func Start(Entity, World):
	if 'FireDamage' in Entity:
		Entity.FireDamage += Value

func Process(Entity, World):
	pass

func End(Entity, World):
	if 'FireDamage' in Entity:
		Entity.FireDamage -= Value
