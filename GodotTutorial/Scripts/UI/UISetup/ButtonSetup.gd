extends Button

@onready var uiSetupManager = $"../../.."


func _ready():
	pass


func _on_button_down():
	uiSetupManager.SwitchUIsVisible();
