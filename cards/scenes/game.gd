extends Node2D

const keys: Array[int] = [KEY_ENTER, KEY_KP_ENTER]


@export var initial_delay: float = 0.5;
var tweens: Array[Tween] = []
var is_tweening: bool = false
signal all_tweens_finished


func _ready() -> void:
	# Hook up to the 'all tweens finished' signal
	all_tweens_finished.connect(on_all_tweens_finished)
	tween_cards()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode in keys:
			if not is_tweening:
				tween_cards()


func tween_cards() -> void:
	if is_tweening:
		return
	else:
		is_tweening = true
	# 1 second delay before tweening begins
	#await get_tree().create_timer(1.0).timeout
	var accumulated_start_delay: float = 0.0;
	# All cards tween at once, with different start time offsets
	for i in get_children():
		i = i as Card
		accumulated_start_delay += initial_delay
		# Start tweening for this card
		var tween: Tween = i.start_tween(accumulated_start_delay)
		print(str(tween.get_instance_id(), " started"))
		# Add this tween to the list
		tweens.push_back(tween)
		# Tween will report it has finished to the check_all_tweens_finished function
		tween.finished.connect(check_all_tweens_finished, Tween.CONNECT_ONE_SHOT)


func check_all_tweens_finished() -> bool:
	for i in tweens:
		# is the tween still alive? We only need one to be alive to know we're not finished overall.
		if i.is_running():
			# We're not finished overall yet. Do nothing.
			return false
	# No running tweens.  We're done overall.
	tweens = []
	is_tweening = false
	# Announce we have finished.
	all_tweens_finished.emit()
	return true


func on_all_tweens_finished() -> void:
	print("All tweens finished! Press ENTER to repeat.")
