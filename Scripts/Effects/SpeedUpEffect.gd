extends Effect

class_name SpeedUpEffect

@export var Value:float = 0

func ExecuteValue(expression:String, VarNames:Array, VarValues:Array):
	var exp:Expression = Expression.new()
	var Error = exp.parse(expression, VarNames)
	if Error != OK:
		push_error(exp.get_error_text())
		return null
	return exp.execute(VarValues)

func Start(Entity, World):
	if 'Speed' in Entity:
		Entity.Speed += Value
		Entity.RotationSpeed += Value

func End(Entity, World):
	if 'Speed' in Entity:
		Entity.Speed -= Value
		Entity.RotationSpeed -= Value
