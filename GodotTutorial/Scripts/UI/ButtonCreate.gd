extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_button_down():
	MapBlockVar.IsCreationMode = true;
	get_tree().change_scene_to_file("res://Scenes/MainScene/CreationScene.tscn")
