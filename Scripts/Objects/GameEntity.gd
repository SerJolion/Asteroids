extends RigidBody2D

class_name GameEntity

signal HealthChanged(NewValue, MaxValue)
signal EnergyChanged(NewValue, MaxValue)
signal EffectAdded(effect:Effect)
signal EffectRemoved(EffectId)
signal Destroed

@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var ContactDamage:float = 50.0

var Health:float = 1 : set = SetHealth
var Energy:float = 1 : set = SetEnergy
var Invincible:bool = false
var Effects:Dictionary = {}

func _process(delta):
	pass

func AddEffect(_Effect:Effect):
	if not _Effect.Id in Effects.keys():
		Effects[_Effect.Id] = _Effect
		_Effect.Start(self,get_parent())
		EffectAdded.emit(_Effect)

func ProcessEffects(delta:float):
	for EffectId in Effects.keys():
		var _Effect:Effect = Effects[EffectId]
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
	Health = clamp(value, 0, MaxHealth)
	HealthChanged.emit(Health, MaxHealth)
	if Health <= 0:
		Destroy()

func SetEnergy(value:float)->void:
	Energy = clamp(value, 0, MaxEnergy)
	EnergyChanged.emit(value, MaxEnergy)

func Hurt(Damage:float):
	if !Invincible:
		Health -= Damage

func Destroy():
	Destroed.emit()
	queue_free()
