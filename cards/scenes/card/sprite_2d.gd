class_name Card extends Node2D

const PI2: float = 6.283185307

enum EaseTypes {
	IN = Tween.EASE_IN,
	OUT = Tween.EASE_OUT,
	IN_OUT = Tween.EASE_IN_OUT,
	OUT_IN = Tween.EASE_OUT_IN,
}

enum TransTypes {
	Linear = Tween.TRANS_LINEAR,
	Spring = Tween.TRANS_SPRING,
	Cubic = Tween.TRANS_CUBIC,
	Elastic = Tween.TRANS_ELASTIC,
	Bounce = Tween.TRANS_BOUNCE,
	Circle = Tween.TRANS_CIRC,
	Exponential = Tween.TRANS_EXPO,
}

@export_category("Card Params")
@export var trans_type: TransTypes
@export var ease_type: EaseTypes
@export var rotation_factor: float = 15.0
@export var rotation_duration: float = 0.1
@export var scale_factor: float = 0.8
@export var scale_amount: float = 0.2
@export var reset_duration: float = 0.25

@onready var rotation_orig: float = rotation
@onready var scale_orig: Vector2 = scale


func start_tween(delay: float) -> Tween:
	var tween: Tween = create_tween()
	tween.set_trans(trans_type as int).set_ease(ease_type as int)

	# First, reset cards to orig rotation/scale
	# By default, tweens run in parallel, so no 'set_parallel' needed here
	tween.tween_property(self, "rotation_degrees", rotation_orig, reset_duration) # TWEEN 1
	tween.tween_property(self, "scale", scale_orig, reset_duration) # TWEEN 2
	# Tween 1 & 2 now running in parallel.

	# Next, tween rotation and scale in parallel AFTER Tweens 1 & 2 finish in parallel.
	# Wait for all above 'reset' tweening to finish before continuing,
	# so we must switch to 'chaining' mode, or the tweens below would run parallel with Tweens 1 & 2.
	tween.chain().tween_property(self, "rotation_degrees", rotation_factor, rotation_duration) # TWEEN 3
	tween.set_parallel().tween_method(tween_scale, 0.0, scale_factor, rotation_duration) # TWEEN 4
	return tween


func tween_scale(value: float) -> void:
	scale = scale_orig + Vector2.ONE * sin((value/scale_factor) * PI2 * 1.0) * scale_amount
