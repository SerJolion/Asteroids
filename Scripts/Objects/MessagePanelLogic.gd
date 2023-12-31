extends Panel

@onready var TextLabel:RichTextLabel = $MarginContainer/VBoxContainer/ScrollContainer/RichTextLabel
@onready var OkButton:Button = $MarginContainer/VBoxContainer/MessageOkButton

var Callback:Callable
var UserInterface:Control

func _ready():
	scale = Vector2(0.1,0.1)
	var tween:Tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(1,1), 0.2)
	Global.Pause(true)

func _exit_tree():
	Global.Pause(false)

func SetText(Text:String):
	if TextLabel != null:
		TextLabel.text = Text

func SetCallback(callback:Callable):
	Callback = callback

func ShowText():
	var tween:Tween = create_tween()
	tween.tween_property(TextLabel,'visible_characters',len(TextLabel.text),2)

func _on_message_ok_button_pressed():
	var tween:Tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(0.1,0.1), 0.2)
	tween.tween_callback(Callback)
	tween.tween_callback(call_deferred.bind('queue_free'))
	tween.tween_callback(Global.Pause.bind(false))
