extends Node2D

@onready var cpu_particles_2d = $CPUParticles2D

func _ready():
	cpu_particles_2d.one_shot = true;
	cpu_particles_2d.emitting = true;


func SetRadius(boomRadius: float) -> void:
	var boomLifeTime: float = 0.5;
	#cpu_particles_2d.lifetime = boomLifeTime;
	var velocity_max: float = boomRadius / boomLifeTime;
	#cpu_particles_2d.initial_velocity_max = velocity_max;
	#cpu_particles_2d.angular_velocity_min = velocity_max / 2;
	#cpu_particles_2d.emitting = true;
	#cpu_particles_2d.emitting = true;


func _on_cpu_particles_2d_finished():
	get_tree().get_first_node_in_group("TileMap").Boom(global_position, 32);
	queue_free();
