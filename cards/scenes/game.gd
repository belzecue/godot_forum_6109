extends Node2D


@export var rotation_delay: float = 0.5;
var tweens: Array[Tween] = []
signal all_tweens_finished


func _ready() -> void:
	# Hook up to the 'all tweens finished' signal
	all_tweens_finished.connect(on_all_tweens_finished)
	pause()


func pause() -> void:
	# 2 second delay before tweening begins
	await get_tree().create_timer(2.0).timeout
	tween_cards()


func tween_cards() -> void:
	var accumulated_rotation_delay: float = 0.0;
	# All cards tween at once, with different start time offsets
	for i in get_children():
		i = i as Card
		accumulated_rotation_delay += rotation_delay
		# Start tweening for this card
		var tween: Tween = i.start_tween(accumulated_rotation_delay)
		print(str(tween.get_instance_id(), " started"))
		# Add this tween to the list
		tweens.push_back(tween)
		# Tween will report it has finished to the check_all_tweens_finished function
		tween.finished.connect(check_all_tweens_finished, CONNECT_ONE_SHOT)


func check_all_tweens_finished() -> bool:
	for i in tweens:
		# is the tween still alive? We only need one to be alive to know we're not finished overall.
		if i.is_running():
			# We're not finished overall yet. Do nothing.
			return false
	# No running tweens.  We're done overall.
	tweens = []
	# Announce we have finished.
	all_tweens_finished.emit()
	return true


func on_all_tweens_finished() -> void:
	print("All tweens finished!!")
