extends Node

var Gravity: float;

func _ready():
	Gravity = ProjectSettings.get_setting("physics/2d/default_gravity");
