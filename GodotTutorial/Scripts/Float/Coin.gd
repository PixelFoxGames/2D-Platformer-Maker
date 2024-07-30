extends Area2D


@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var animation_player = $AnimationPlayer
var hasBeenCollected:bool = false;


func _on_body_entered(body):
	if hasBeenCollected:
		return;
	hasBeenCollected = true;
	body.GetCoin();
	audio_stream_player_2d.play();
	animation_player.play("GetCoin");
	animation_player.active = true;


func _on_audio_stream_player_2d_finished():
	queue_free();
