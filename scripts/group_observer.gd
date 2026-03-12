class_name GroupObserver extends RefCounted

var _group_size : int = 0

signal done

func _init(group_size : int) -> void:
	_group_size = group_size
	assert(_group_size > 0)

func one_signal_ended() -> void:
	_group_size -= 1
	if _group_size <= 0:
		done.emit()
