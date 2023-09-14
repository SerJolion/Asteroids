extends Control

@onready var Title:Label = $Panel/MarginContainer/VBoxContainer/Title
@onready var RestarButton:Button = $Panel/MarginContainer/VBoxContainer/RestartButton
@onready var ExitButton:Button = $Panel/MarginContainer/VBoxContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SetTitle(value:String, TitleColor:Color=Color.WHITE)->void:
	Title.modulate = TitleColor
	Title.text = value

func _on_restart_button_pressed():
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()
