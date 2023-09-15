extends Resource

class_name Effect

const INSTANT_TYPE = 0
const CONSTANT_TYPE = 1
const TEMPORARY_TYPE = 2


@export var Id:String = 'empty_effect'
@export var DisplayName:String
@export_multiline var Description:String = ' '
@export var VisibleIcon:bool = false
@export_file('*') var PathToIcon:String
@export var LifeTime:float
@export_enum('Instant','Constant','Temporary') var Type:int

func Start(Entity, World):
	pass

func Process(Entity, World):
	pass

func End(Entity, World):
	pass
