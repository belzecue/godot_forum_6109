class_name Card extends Node2D

const PI2: float = 6.283185307
const reset_duration: float = 0.5

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
@export var rotation_target: float = 15.0
@export var tweener_duration: float = 0.1
@export var start_delay: float = 1.0
@export var scale_factor: float = 0.8

@onready var rotation_orig: float = rotation
@onready var scale_orig: Vector2 = scale


func start_tween() -> Tween:
	var tween: Tween = create_tween()
	tween.set_trans(trans_type as int).set_ease(ease_type as int)

	# First, reset cards to orig rotation/scale
	# By default, tweeners run sequentially, so 'parallel' needed here for second tweener.
	tween.tween_property(self, "rotation_degrees", rotation_orig, reset_duration) # TWEEN 1
	tween.parallel().tween_property(self, "scale", scale_orig, reset_duration) # TWEEN 2
	# Tween 1 & 2 now running in parallel.

	# Next, tween rotation and scale (Tween 3 & 4) in parallel AFTER Tweens 1 & 2 finish in parallel.
	# First, pause according to the tweener's start delay.
	tween.tween_interval(start_delay)
	tween.tween_property(self, "rotation_degrees", rotation_target, tweener_duration) # TWEEN 3
	tween.parallel().tween_property(self, "scale", scale_orig * scale_factor, tweener_duration) # TWEEN 4
	return tween
