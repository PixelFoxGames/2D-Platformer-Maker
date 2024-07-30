extends Button


func _ready():
	if LevelData.new().LoadLevelNameList().size() > 0:
		disabled = false;
	else:
		disabled = true;


func _on_button_down():
	MapBlockVar.IsCreationMode = false;
	get_tree().change_scene_to_file("res://Scenes/MainScene/GameScene.tscn");
