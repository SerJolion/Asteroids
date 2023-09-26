extends "res://Scripts/Objects/AsteroidLogic.gd"

func Destroy():
	randomize()
	var Chance = randf()
	if Chance <= 0.5:
		var Loot:Node2D = load("res://Objects/Powerups/FuelPowerUp.tscn").instantiate()
		get_parent().Add2DObject(Loot, global_position)
	get_parent().AddParticlesObject(30, true, 1.5, true, DestroyParticlesMaterial, position, Visual.color)
	get_parent().AddSoundObject('res://Sound/AsteroidDestroy.mp3', position)
	Destroed.emit()
	call_deferred('queue_free')
