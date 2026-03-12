class_name ItemPickup extends Area2D

@export var _item_data : ItemData = null

@onready var _item_sprite : Sprite2D = $Sprite
@onready var _audio_player : AudioStreamPlayer2D = $AudioPlayer

var _group_observer : GroupObserver = null

var _destruct_triggered : bool = false
var _collected : bool = false

func _refresh_visual() -> void:
	_item_sprite.texture = _item_data.world_texture
	if not _item_sprite.texture:
		push_warning("Unavailable texture")

func _ready() -> void:
	if not _item_data:
		push_warning("Empty %s" % self.get_class())
		self.queue_free()
		return
	_refresh_visual()

func look_item() -> ItemData:
	return _item_data

func collect() -> ItemData:
	if _collected:
		return null
	_collected = true
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	return _item_data

func destruct() -> void:
	if _destruct_triggered:
		return
	_destruct_triggered = true
	var signal_count = 1
	if _item_data.collect_sfx:
		_audio_player.stream = _item_data.collect_sfx
		_audio_player.play()
		signal_count += 1
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	_group_observer = GroupObserver.new(signal_count)
	var tween : Tween = self.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(_item_sprite, "rotation", _item_sprite.rotation + 3.0 * TAU , 0.4)
	tween.parallel().tween_property(_item_sprite, "modulate:a", 0.0, 0.4)
	var scale_tween := create_tween()
	scale_tween.tween_property(_item_sprite, "scale", Vector2.ONE * 1.4, 0.1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(_item_sprite, "scale", Vector2.ZERO, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	tween.parallel().tween_subtween(scale_tween)
	tween.finished.connect(_group_observer.one_signal_ended)
	_audio_player.finished.connect(_group_observer.one_signal_ended)
	_group_observer.done.connect(queue_free)
