class_name Card extends Node2D

@export_group("Rotation params")
@export var rotation_factor: float = 15.0;
@export var rotation_duration: float = 0.1;


func start_tween(delay: float) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_interval(delay)
	tween.tween_property(self, "rotation_degrees", rotation_factor, rotation_duration)
	return tween
