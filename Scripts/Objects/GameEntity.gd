extends RigidBody2D

class_name GameEntity

signal HealthChanged(NewValue, MaxValue)
signal EnergyChanged(NewValue, MaxValue)
signal EffectAdded(effect:Effect)
signal EffectRemoved(EffectId)

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var ContactDamage:float = 50.0

var Health:float = 1 : set = SetHealth
var Energy:float = 1 : set = SetEnergy
var Effects:Dictionary = {}

func _process(delta):
	pass

func AddEffect(_Effect:Effect):
	if not _Effect.Id in Effects.keys():
		Effects[_Effect.Id] = _Effect
		_Effect.Start(self,get_parent())
		EffectAdded.emit(_Effect)

func ProcessEffect(_Effect:Effect, World:Node2D, delta:float):
	_Effect.Process(self,get_parent())
	match _Effect.Type:
		0:
			RemoveEffect(_Effect.Id)
		1:
			pass
		2:
			_Effect.LifeTime -= delta
			if _Effect.LifeTime <= 0:
				RemoveEffect(_Effect.Id)

func RemoveEffect(EffectId:String):
	if EffectId in Effects.keys():
		Effects[EffectId].End(self,get_parent())
		Effects.erase(EffectId)
		EffectRemoved.emit(EffectId)

func SetHealth(value:float)->void:
	HealthChanged.emit(value, MaxHealth)
	Health = value
	if Health <= 0:
		Destroy()

func SetEnergy(value:float)->void:
	EnergyChanged.emit(value, MaxEnergy)
	Energy = value

func Destroy():
	queue_free()
