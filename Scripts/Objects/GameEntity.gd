extends RigidBody2D

class_name GameEntity

signal HealthChanged(NewValue, MaxValue)
signal EnergyChanged(NewValue, MaxValue)
signal EffectAdded(effect:Effect)
signal EffectRemoved(EffectId)
signal Destroed

@export_node_path("CanvasItem") var VisualNode:NodePath
@export_node_path("Node2D") var ColiderNode:NodePath
@export_node_path("AudioStreamPlayer2D") var AudioPlayerNode:NodePath
@export_category('Movement')
@export var Speed:float = 150.0
@export var RotationSpeed:float = 150.0
@export_category('Gameplay')
@export var MaxHealth:float = 100.0
@export var MaxEnergy:float = 100.0
@export var ContactDamage:float = 50.0
@export var CanTakePowerups:bool = false
@export_file('*.tscn') var DropScenePath:String

@onready var Visual:Polygon2D = get_node(VisualNode)
@onready var Colider:CollisionPolygon2D = get_node(ColiderNode)
@onready var AudioPlayer:AudioStreamPlayer2D = get_node(AudioPlayerNode)
#@onready var DropScene:PackedScene = load(DropScenePath)

var Health:float = MaxHealth : set = SetHealth
var Energy:float = MaxEnergy : set = SetEnergy
var Invincible:bool = false
var Effects:Dictionary = {}

func _integrate_forces(state):
	if linear_velocity.length() > Speed:
		linear_velocity = linear_velocity.normalized() * Speed

func _process(delta):
	pass

func AddEffect(_Effect:Effect):
	if not _Effect.Id in Effects.keys():
		Effects[_Effect.Id] = _Effect.duplicate()
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
		var e:Effect
		Effects[EffectId].End(self,get_parent())
		Effects.erase(EffectId)
		EffectRemoved.emit(EffectId)

func SetColor(color:Color):
	if Visual != null:
		Visual.color = color
	else:
		push_warning('{0}:Невозможно поменять цвет. Отсутсвует Visual'.format([name]))

func GetColor()->Color:
	if Visual != null:
		return Visual.color
	else:
		push_warning('{0}:Невозможно получить цвет. Отсутсвует Visual'.format([name]))
		return Color.WHITE

func PlaySound(Sound:AudioStream):
	if AudioPlayer != null:
		AudioPlayer.stream = Sound
		AudioPlayer.play()
	else:
		push_warning('{0}:Невозможно проиграть звук. отсутсвует AudioStreamPlayer'.format([name]))

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
	#if DropScene != null:
		#var Drop:Node2D = DropScene.instantiate()
		#get_parent().add_child(Drop)
		#Drop.position = position
	call_deferred('queue_free')
